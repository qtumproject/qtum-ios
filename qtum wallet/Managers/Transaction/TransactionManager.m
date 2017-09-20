//
//  TransactionManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
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
#import "NSNumber+Comparison.h"
#import "TransactionScriptBuilder.h"

static NSString* op_exec = @"c1";

@interface TransactionManager ()

@property (strong, nonatomic) TransactionBuilder* transactionBuilder;
@property (assign, nonatomic) NSUInteger fee;
@property (strong, nonatomic) NSNumber* feePerKb;

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
        _transactionBuilder = [[TransactionBuilder alloc] initWithScriptBuilder:[TransactionScriptBuilder new]];
    }
    return self;
}

-(void)getFeePerKbWithHandler:(void(^)(NSNumber* feePerKb)) completion {
    if (self.feePerKb) {
        return completion(self.feePerKb);
    }
    
    
}


- (void)sendTransactionWalletKeys:(NSArray<BTCKey*> *)walletKeys
               toAddressAndAmount:(NSArray *)amountsAndAddresses
                              fee:(NSDecimalNumber*) fee
                       andHandler:(void(^)(TransactionManagerErrorType errorType,
                                           id response))completion {
    
    NSAssert(amountsAndAddresses && walletKeys.count > 0, @"Amount and address must be not nil, from addresses must be grater then one");
    
    self.fee = [self feeFromNumber:fee];
    
    __weak typeof(self) weakSelf = self;
    NSArray* walletAddreses = [self getAddressesFromKeys:walletKeys];
    NSDictionary* allPreparedValues = [self createAmountsAndAddresses:amountsAndAddresses];
    
    if (!allPreparedValues) {
        completion(TransactionManagerErrorTypeInvalidAddress, nil);
        return;
    }
    
    BTCAmount amount = [allPreparedValues[@"totalAmount"] doubleValue];
    NSArray* preparedAmountAndAddreses = allPreparedValues[@"amountsAndAddresses"];
    
    [[ApplicationCoordinator sharedInstance].walletManager.requestAdapter getunspentOutputs:walletAddreses withSuccessHandler:^(NSArray <BTCTransactionOutput*>*responseObject) {
        
        [weakSelf.transactionBuilder regularTransactionWithUnspentOutputs:responseObject amount:amount amountAndAddresses:preparedAmountAndAddreses withFee:self.fee walletKeys:walletKeys andHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction) {
            if (errorType == TransactionManagerErrorTypeNone) {
                [weakSelf sendTransaction:transaction withSuccess:^(id response){
                    completion(TransactionManagerErrorTypeNone, response);
                } andFailure:^(NSString *message) {
                    completion(TransactionManagerErrorTypeServer, message);
                }];
            } else {
                completion(errorType, nil);
            }
        }];
    } andFailureHandler:^(NSError *error, NSString *message) {
        completion([error isNoInternetConnectionError] ? TransactionManagerErrorTypeNoInternetConnection :TransactionManagerErrorTypeServer, nil);
    }];
}

- (void)sendTransactionToToken:(Contract *)token
                     toAddress:(NSString *)toAddress
                        amount:(NSNumber *)amount
                           fee:(NSDecimalNumber*) fee
                    andHandler:(void(^)(TransactionManagerErrorType errorType,
                                        BTCTransaction * transaction,
                                        NSString* hashTransaction)) completion {
    
    NSString* __block addressWithAmountValue;
    [token.addressBalanceDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* address, NSNumber* balance, BOOL * _Nonnull stop) {
        if ([balance isGreaterThan:amount]) {
            addressWithAmountValue = address;
            *stop = YES;
        }
    }];
    
    [self sendToken:token fromAddress:addressWithAmountValue toAddress:toAddress amount:[amount decimalNumber] fee:fee andHandler:completion];
}

- (void)sendToken:(Contract*) token
      fromAddress:(NSString*) frommAddress
        toAddress:(NSString*) toAddress
           amount:(NSDecimalNumber*) amount
              fee:(NSDecimalNumber*) fee
       andHandler:(void(^)(TransactionManagerErrorType errorType,
                           BTCTransaction * transaction,
                           NSString* hashTransaction)) completion {
    
    // Checking address
    BTCPublicKeyAddress *address = [BTCPublicKeyAddress addressWithString:toAddress];
    if (!address) {
        completion(TransactionManagerErrorTypeInvalidAddress, nil, nil);
    }
    
    AbiinterfaceItem* transferMethod = [[ContractInterfaceManager sharedInstance] tokenStandartTransferMethodInterface];
    NSData* hashFuction = [[ContractInterfaceManager sharedInstance] hashOfFunction:transferMethod appendingParam:@[toAddress,[amount stringValue]]];
    
    NSString* __block addressWithAmountValue = frommAddress;
    
    NSNumber* addressBalance = token.addressBalanceDictionary[addressWithAmountValue];
    
    if (addressBalance) {
        if ([addressBalance isLessThan:amount]) {
            completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil);
            return;
        }
    } else {
        completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil);
        return;
    }

    if (addressWithAmountValue && amount) {
        
        [[[self class] sharedInstance] callTokenWithAddress:[NSString dataFromHexString:token.contractAddress]
                                                 andBitcode:hashFuction fromAddresses:@[addressWithAmountValue]
                                                  toAddress:nil
                                                 walletKeys:[ApplicationCoordinator sharedInstance].walletManager.wallet.allKeys
                                                        fee:fee
                                                 andHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction) {
                                                     
            completion(errorType, transaction, hashTransaction);
        }];
    } else {
        completion(TransactionManagerErrorTypeNotEnoughMoney, nil, nil);
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
                  andHandler:(void(^)(TransactionManagerErrorType errorType, BTCTransaction * transaction, NSString* hashTransaction)) completion {
    
    [self sendTokensToTokensAddress:contractAddress
                      withBitcode:bitcode
                   fromAddresses:fromAddresses
                       toAddress:toAddress
                      withWalletKeys:walletKeys
                            withFee:fee
                      withHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction) {
        completion(errorType,transaction,hashTransaction);
    }];
}

- (void)sendTokensToTokensAddress:(NSData*) contractAddress
                      withBitcode:(NSData*) bitcode
                    fromAddresses:(NSArray<NSString*>*) fromAddresses
                        toAddress:(NSString*) toAddress
                   withWalletKeys:(NSArray<BTCKey*>*) walletKeys
                          withFee:(NSDecimalNumber*) fee
                      withHandler:(void(^)(TransactionManagerErrorType errorType,
                                           BTCTransaction * transaction,
                                           NSString* hashTransaction)) completion {
    
    if (!fromAddresses.count) {
        completion(TransactionManagerErrorTypeInvalidAddress,nil,nil);
    }
    
    self.fee = [self feeFromNumber:fee];
    
    __weak typeof(self) weakSelf = self;
    
    [[ApplicationCoordinator sharedInstance].walletManager.requestAdapter getunspentOutputs:fromAddresses
                                                                         withSuccessHandler:^(NSArray <BTCTransactionOutput*>*responseObject) {
        
        BTCTransaction *tx = [weakSelf.transactionBuilder callContractTxWithUnspentOutputs:responseObject
                                                                                 amount:0
                                                                        contractAddress:contractAddress
                                                                              toAddress:toAddress
                                                                          fromAddresses:fromAddresses
                                                                                bitcode:bitcode
                                                                                withFee:self.fee
                                                                             walletKeys:walletKeys];
        
        if (!tx) {
            completion(TransactionManagerErrorTypeNotEnoughMoney,nil,nil);
        } else {
            [weakSelf sendTransaction:tx withSuccess:^(id response){
                completion(TransactionManagerErrorTypeNone,tx,response[@"txid"]);
            } andFailure:^(NSString *message) {
                completion(TransactionManagerErrorTypeServer,nil,nil);
            }];
        }

    } andFailureHandler:^(NSError *error, NSString *message) {
        completion(TransactionManagerErrorTypeServer,nil, nil);
    }];
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
        return [[value decimalNumberByMultiplyingBy:[[NSDecimalNumber alloc] initWithInt:BTCCoin]] unsignedLongLongValue];
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

