//
//  TransactionManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "TransactionManager.h"
#import "RequestManager.h"
#import "RPCRequestManager.h"
#import "NSString+Extension.h"
#import "ContractInterfaceManager.h"
#import "NS+BTCBase58.h"
#import "ContractArgumentsInterpretator.h"
#import "WalletManagerRequestAdapter.h"
#import "Wallet.h"
#import "NSNumber+Comparison.h"
#import "TransactionScriptBuilder.h"

static NSString* op_exec = @"c1";

@interface TransactionManager ()

@property (strong, nonatomic) TransactionBuilder* transactionBuilder;
@property (strong, nonatomic) TransactionScriptBuilder* scriptBuilder;

@property (assign, nonatomic) NSUInteger fee;
@property (strong, nonatomic) NSDecimalNumber* feePerKb;

@end

static NSInteger constantFee = 10000000;

@implementation TransactionManager

+ (instancetype)sharedInstance {
    
    static TransactionManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    if (self) {
        _scriptBuilder = [TransactionScriptBuilder new];
        _transactionBuilder = [[TransactionBuilder alloc] initWithScriptBuilder:_scriptBuilder];
    }
    return self;
}

-(void)getFeePerKbWithHandler:(void(^)(NSDecimalNumber* feePerKb)) completion {
    
    if (self.feePerKb) {
        return completion(self.feePerKb);
    }
    
    [[ApplicationCoordinator sharedInstance].requestManager getFeePerKbWithSuccessHandler:^(NSNumber *feePerKb) {
        completion([feePerKb decimalNumber]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        completion(nil);
    }];
}

-(void)getFeeWithContractAddress:(NSString*) address
                      withHashes:(NSArray*) hashes
                     withHandler:(void(^)(NSDecimalNumber* gas))completesion {
    
    [[ApplicationCoordinator sharedInstance].requestManager callFunctionToContractAddress:address withHashes:hashes withHandler:^(id responseObject) {
        
        NSNumber* gas = responseObject[@"items"][0][@"gas_used"];
        if ([gas isKindOfClass:[NSNumber class]]) {
            completesion([gas decimalNumber]);
        } else {
            completesion(nil);
        }
    }];
}


- (void)sendTransactionWalletKeys:(NSArray<BTCKey*> *)walletKeys
               toAddressAndAmount:(NSArray *)amountsAndAddresses
                              fee:(NSDecimalNumber*) fee
                       andHandler:(void(^)(TransactionManagerErrorType errorType,
                                           id response,
                                           NSDecimalNumber* estimatedFee))completion {
    
    NSOperationQueue* requestQueue = [[NSOperationQueue alloc] init];

    __weak typeof(self) weakSelf = self;

    dispatch_block_t block = ^{
        
        NSArray* walletAddreses = [weakSelf getAddressesFromKeys:walletKeys];
        NSDictionary* allPreparedValues = [weakSelf createAmountsAndAddresses:amountsAndAddresses];
        
        if (!allPreparedValues) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(TransactionManagerErrorTypeInvalidAddress, nil, nil);
            });
            return;
        }
        
        BTCAmount amount = [allPreparedValues[@"totalAmount"] doubleValue];
        
        NSArray* preparedAmountAndAddreses = allPreparedValues[@"amountsAndAddresses"];
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        NSArray <BTCTransactionOutput*>* __block unspentOutputs = @[];
        
        [[ApplicationCoordinator sharedInstance].walletManager.requestAdapter getunspentOutputs:walletAddreses withSuccessHandler:^(NSArray <BTCTransactionOutput*>*responseObject) {
            
            unspentOutputs = responseObject;
            dispatch_semaphore_signal(semaphore);
            
        } andFailureHandler:^(NSError *error, NSString *message) {
            
            completion([error isNoInternetConnectionError] ?
                       TransactionManagerErrorTypeNoInternetConnection :
                       TransactionManagerErrorTypeServer, nil, nil);
            return;
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSDecimalNumber* __block feePerKb;
        
        [weakSelf getFeePerKbWithHandler:^(NSDecimalNumber *aFeePerKb) {
            
            if (aFeePerKb) {
                
                feePerKb = aFeePerKb;
                dispatch_semaphore_signal(semaphore);
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(TransactionManagerErrorTypeServer, nil, nil);
                });
                return;
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        BTCTransaction* __block transaction;
        TransactionManagerErrorType __block errorType;
        NSDecimalNumber* __block estimatedFee = fee;
        NSDecimalNumber* __block passedFee;
        
        do {
            [weakSelf.transactionBuilder regularTransactionWithUnspentOutputs:unspentOutputs
                                                                       amount:amount
                                                           amountAndAddresses:preparedAmountAndAddreses
                                                                      withFee:[self feeFromNumber:estimatedFee]
                                                                   walletKeys:walletKeys
                                                                   andHandler:^(TransactionManagerErrorType aErrorType, BTCTransaction *aTransaction) {
                                                                       
                                                                       transaction = aTransaction;
                                                                       errorType = aErrorType;
                                                                       
                                                                       if (transaction) {
                                                                           passedFee = estimatedFee;
                                                                           estimatedFee = [estimatedFee decimalNumberByAdding:feePerKb];
                                                                       }
                                                                   }];
            
        } while (transaction &&
                 [self convertValueToAmount:passedFee] < [transaction estimatedFeeWithRate:[self convertValueToAmount:feePerKb]]);
        
        if (transaction && [passedFee isEqualToDecimalNumber:fee]) {
            
            [weakSelf sendTransaction:transaction withSuccess:^(id response){
                completion(TransactionManagerErrorTypeNone, response, nil);
            } andFailure:^(NSString *message) {
                completion(TransactionManagerErrorTypeServer, message, nil);
            }];

        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (transaction) {
                    
                    completion(TransactionManagerErrorTypeNotEnoughFee, nil, passedFee);
                } else {
                    
                    completion(errorType, nil, nil);
                }
            });
        }
    };
    
    [requestQueue addOperationWithBlock:block];
}

- (void)sendTransactionToToken:(Contract *)token
                     toAddress:(NSString *)toAddress
                        amount:(NSNumber *)amount
                           fee:(NSDecimalNumber*) fee
                  withGasLimit:(NSDecimalNumber*) gasLimit
                    andHandler:(void(^)(TransactionManagerErrorType errorType,
                                        BTCTransaction * transaction,
                                        NSString* hashTransaction,
                                        NSDecimalNumber* estimatedFee)) completion {
    
    NSString* __block addressWithAmountValue;
    [token.addressBalanceDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* address, NSNumber* balance, BOOL * _Nonnull stop) {
        if ([balance isGreaterThan:amount]) {
            addressWithAmountValue = address;
            *stop = YES;
        }
    }];
    
    [self sendToken:token
        fromAddress:addressWithAmountValue
          toAddress:toAddress amount:[amount decimalNumber]
                fee:fee
       withGasLimit:gasLimit
         andHandler:completion];
}

- (void)sendToken:(Contract*) token
      fromAddress:(NSString*) fromAddress
        toAddress:(NSString*) toAddress
           amount:(NSDecimalNumber*) amount
              fee:(NSDecimalNumber*) fee
     withGasLimit:(NSDecimalNumber*) gasLimit
       andHandler:(void(^)(TransactionManagerErrorType errorType,
                           BTCTransaction * transaction,
                           NSString* hashTransaction,
                           NSDecimalNumber* estimatedFee)) completion {
    
    // Checking address
    BTCPublicKeyAddress *address = [BTCPublicKeyAddress addressWithString:toAddress];
    if (!address) {
        completion(TransactionManagerErrorTypeInvalidAddress, nil, nil, nil);
    }
    
    AbiinterfaceItem* transferMethod = [[ContractInterfaceManager sharedInstance] tokenStandartTransferMethodInterface];
    NSData* hashFuction = [[ContractInterfaceManager sharedInstance] hashOfFunction:transferMethod appendingParam:@[toAddress,[amount stringValue]]];
    
    NSString* __block addressWithAmountValue = fromAddress;
    
    NSNumber* addressBalance = token.addressBalanceDictionary[addressWithAmountValue];
    
    if (addressBalance) {
        if ([addressBalance isLessThan:amount]) {
            completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil,nil);
            return;
        }
    } else {
        completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil, nil);
        return;
    }

    if (addressWithAmountValue && amount) {
        
        NSDecimalNumber* gasLimit;
        
        
        
        [[[self class] sharedInstance] callTokenWithAddress:[NSString dataFromHexString:token.contractAddress]
                                                 andBitcode:hashFuction
                                              fromAddresses:@[addressWithAmountValue]
                                                  toAddress:nil
                                                 walletKeys:[ApplicationCoordinator sharedInstance].walletManager.wallet.allKeys
                                                        fee:fee
                                               withGasLimit:gasLimit
                                                 andHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction, NSDecimalNumber* estimatedFee) {
                                                     
            completion(errorType, transaction, hashTransaction, estimatedFee);
        }];
    } else {
        completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil, nil);
    }
}

- (void)createSmartContractWithKeys:(NSArray<BTCKey*> *)walletKeys
                         andBitcode:(NSData *)bitcode
                                fee:(NSDecimalNumber*) fee
                         andHandler:(void(^)(NSError *error,
                                             BTCTransaction *transaction,
                                             NSString *hashTransaction)) completion {
    
    //NSAssert(walletKeys.count > 0, @"Keys must be grater then zero");
    if (!walletKeys.count) {
        completion([NSError new],nil,nil);
    }
    
    self.fee = constantFee;
    
    __weak typeof(self) weakSelf = self;
    NSArray* walletAddreses = [self getAddressesFromKeys:walletKeys];
    
    [[ApplicationCoordinator sharedInstance].walletManager.requestAdapter getunspentOutputs:walletAddreses withSuccessHandler:^(NSArray <BTCTransactionOutput*>*responseObject) {
        
        BTCTransaction *tx = [weakSelf.transactionBuilder smartContractCreationTxWithUnspentOutputs:responseObject
                                                                                         withAmount:0
                                                                                        withBitcode:bitcode
                                                                                            withFee:self.fee
                                                                                     withWalletKeys:walletKeys];
        
        [weakSelf sendTransaction:tx withSuccess:^(id response){
            completion(nil,tx,response[@"txid"]);
        } andFailure:^(NSString *message) {
            completion([NSError new],nil,nil);
        }];
    } andFailureHandler:^(NSError *error, NSString *message) {
        completion(error,nil, nil);
    }];
}

- (void)callTokenWithAddress:(NSData*) contractAddress
                  andBitcode:(NSData*) bitcode
                 fromAddresses:(NSArray<NSString*>*) fromAddresses
                   toAddress:(NSString*) toAddress
                  walletKeys:(NSArray<BTCKey*>*) walletKeys
                         fee:(NSDecimalNumber*) fee
                withGasLimit:(NSDecimalNumber*) gasLimit
                  andHandler:(void(^)(TransactionManagerErrorType errorType,
                                      BTCTransaction * transaction,
                                      NSString* hashTransaction,
                                      NSDecimalNumber* estimatedFee)) completion {
    
    [self sendTokensToTokensAddress:contractAddress
                      withBitcode:bitcode
                   fromAddresses:fromAddresses
                       toAddress:toAddress
                      withWalletKeys:walletKeys
                            withFee:fee
                       withGasLimit:gasLimit
                      withHandler:^(TransactionManagerErrorType errorType,
                                    BTCTransaction *transaction,
                                    NSString *hashTransaction,
                                    NSDecimalNumber* estimatedFee) {
        completion(errorType,transaction,hashTransaction, estimatedFee);
    }];
}

- (void)sendTokensToTokensAddress:(NSData*) contractAddress
                      withBitcode:(NSData*) bitcode
                    fromAddresses:(NSArray<NSString*>*) fromAddresses
                        toAddress:(NSString*) toAddress
                   withWalletKeys:(NSArray<BTCKey*>*) walletKeys
                          withFee:(NSDecimalNumber*) fee
                      withGasLimit:(NSDecimalNumber*) aGasLimit
                      withHandler:(void(^)(TransactionManagerErrorType errorType,
                                           BTCTransaction * transaction,
                                           NSString* hashTransaction,
                                           NSDecimalNumber* estimatedFee)) completion {
    
    
    NSOperationQueue* requestQueue = [[NSOperationQueue alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t block = ^{
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        if (!fromAddresses.count) {
            completion(TransactionManagerErrorTypeInvalidAddress,nil,nil, nil);
        }
        
        NSDecimalNumber* __block gasLimit;

        [weakSelf getFeeWithContractAddress:[NSString hexadecimalString:contractAddress] withHashes:@[[NSString hexadecimalString:bitcode]] withHandler:^(NSDecimalNumber* gas) {
            
            if (gas) {
                gasLimit = gas;
                dispatch_semaphore_signal(semaphore);
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(TransactionManagerErrorTypeOups,nil,nil, nil);
                });
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        NSArray <BTCTransactionOutput*>* __block unspentOutputs = @[];
        
        [[ApplicationCoordinator sharedInstance].walletManager.requestAdapter getunspentOutputs:fromAddresses
                                                                             withSuccessHandler:^(NSArray <BTCTransactionOutput*>*responseObject) {
                                                                                 
                                                                                 unspentOutputs = responseObject;
                                                                                 dispatch_semaphore_signal(semaphore);
                                                                             } andFailureHandler:^(NSError *error, NSString *message) {
                                                                                 
                                                                                 completion(TransactionManagerErrorTypeServer,nil, nil, nil);
                                                                             }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        
        NSDecimalNumber* __block feePerKb;
        
        [weakSelf getFeePerKbWithHandler:^(NSDecimalNumber *aFeePerKb) {
            
            if (aFeePerKb) {
                
                feePerKb = aFeePerKb;
                dispatch_semaphore_signal(semaphore);
            } else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(TransactionManagerErrorTypeServer, nil, nil, nil);
                });
                return;
            }
        }];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        BTCTransaction* __block transaction;
        NSDecimalNumber* __block gas = [[gasLimit decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithLong:BTCCoin]] decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithUnsignedInteger:[weakSelf.scriptBuilder gasPrice]]];
        NSDecimalNumber* __block estimatedFee = fee;
        NSDecimalNumber* __block passedFee;
        TransactionManagerErrorType __block errorType;

        do {
            
           [weakSelf.transactionBuilder callContractTxWithUnspentOutputs:unspentOutputs
                                                                amount:0
                                                       contractAddress:contractAddress
                                                             toAddress:toAddress
                                                         fromAddresses:fromAddresses
                                                               bitcode:bitcode
                                                               withFee:[self feeFromNumber:estimatedFee]
                                                          withGasLimit:gasLimit
                                                            walletKeys:walletKeys
                                                            andHandler:^(TransactionManagerErrorType aErrorType, BTCTransaction *aTransaction) {
                                                                
                                                                transaction = aTransaction;
                                                                errorType = aErrorType;
                                                                
                                                                if (transaction) {
                                                                    passedFee = estimatedFee;
                                                                    estimatedFee = [estimatedFee decimalNumberByAdding:feePerKb];
                                                                }
                                                            }];
            
        } while (transaction &&
                 [weakSelf convertValueToAmount:passedFee] < ([transaction estimatedFeeWithRate:[weakSelf convertValueToAmount:feePerKb]] + [weakSelf convertValueToAmount:gas]));
        
        
        BOOL isUsersFee = [passedFee isEqualToDecimalNumber:fee];
        
        if (transaction && isUsersFee) {
            
            [weakSelf sendTransaction:transaction withSuccess:^(id response){
                
                completion(TransactionManagerErrorTypeNone,transaction,response[@"txid"], nil);
            } andFailure:^(NSString *message) {
                completion(TransactionManagerErrorTypeServer,nil,nil, nil);
            }];
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (transaction) {
                    
                    completion(TransactionManagerErrorTypeNotEnoughFee, nil, nil, passedFee);
                } else {
                    
                    completion(errorType,nil,nil, nil);
                }
            });
        }
    };
    
    [requestQueue addOperationWithBlock:block];
}

- (void)sendTransaction:(BTCTransaction*)transaction withSuccess:(void(^)(id response))success andFailure:(void(^)(NSString *message))failure {
    
    if (transaction) {
        
        [[ApplicationCoordinator sharedInstance].requestManager sendTransactionWithParam:@{@"data":transaction.hexWithTime,@"allowHighFee":@1} withSuccessHandler:^(id responseObject) {
            success(responseObject);
        } andFailureHandler:^(NSString *message) {
            failure(@"Can not send transaction");
        }];
    } else {
        failure (@"Cant Create Transaction");
    }
}


#pragma mark - Private


- (BTCAmount)convertValueToAmount:(NSDecimalNumber*) value {
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return [[value decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:BTCCoin]] intValue];
    }
    return value.doubleValue * BTCCoin;
}


- (NSDictionary*)createAmountsAndAddresses:(NSArray *)array {
    
    NSMutableArray *mutArray = [NSMutableArray new];
    BTCAmount totalAmount = 0;
    for (NSDictionary *dictionary in array) {
        
        BTCPublicKeyAddress *toPublicKeyAddress = [BTCPublicKeyAddress addressWithString:dictionary[@"address"]];
        
        BTCAmount amount = [self convertValueToAmount:dictionary[@"amount"]];
        
        totalAmount += amount;
        
        if (!toPublicKeyAddress) {
            return nil;
        }
        NSDictionary *newDictionary = @{@"address" : toPublicKeyAddress, @"amount" : @(amount)};
        [mutArray addObject:newDictionary];
    }
    return @{@"totalAmount" : @(totalAmount), @"amountsAndAddresses" : [mutArray copy]};
}

-(NSUInteger)feeFromNumber:(NSDecimalNumber*) feeNumber {
    
    if (feeNumber) {
        return [feeNumber decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithLong:BTCCoin]].unsignedLongValue;
    } else {
        return constantFee;
    }
}


-(NSArray*)getAddressesFromKeys:(NSArray<BTCKey*>*) keys{
    
    NSMutableArray *addresesForSending = [NSMutableArray new];
    
    for (BTCKey *key in keys) {
        
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        [addresesForSending addObject:keyString];
    }
    
    NSAssert(addresesForSending.count > 0, @"There is no addresses in keys");
    
    return addresesForSending;
}



@end

