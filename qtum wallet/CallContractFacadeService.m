//
//  CallContractFacadeService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "CallContractFacadeService.h"
#import "ResultTokenInputsModel.h"

@interface CallContractFacadeService()

@property (assign, nonatomic) BOOL queryProcessing;

@end

@implementation CallContractFacadeService

- (void)createSmartContractWithTemplate:(NSString *) templatePath
                               andArray:(NSArray *) args
                                    fee:(QTUMBigNumber *) fee
                               gasPrice:(QTUMBigNumber *) gasPrice
                               gasLimit:(QTUMBigNumber *) gasLimit
                             andHandler:(void (^)(TransactionManagerErrorType errorType,
                                              BTCTransaction *transaction,
                                              NSString *hashTransaction, QTUMBigNumber *estimatedValue)) completion {
    
    
    NSData *contractWithArgs = [SLocator.contractInterfaceManager tokenBitecodeWithTemplate:templatePath andArray:args];
    
    [SLocator.transactionManager createSmartContractWithKeys:SLocator.walletManager.wallet.allKeys
                                                  andBitcode:contractWithArgs
                                                         fee:fee
                                                    gasPrice:gasPrice
                                                    gasLimit:gasLimit
                                                  andHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction, QTUMBigNumber *estimatedValue) {
                                                      completion(errorType,transaction,hashTransaction,estimatedValue);
                                                  }];
}

-(void)callContractFunctionWithItem:(AbiinterfaceItem *) item
                           andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                          andAmount:(QTUMBigNumber*) amount
                        fromAddress:(NSString*) fromAddress
                           andToken:(Contract *) contract
                             andFee:(QTUMBigNumber *) fee
                        andGasPrice:(QTUMBigNumber *) gasPrice
                        andGasLimit:(QTUMBigNumber *) gasLimit
                         andHandler:(void (^)(TransactionManagerErrorType errorType,
                                              BTCTransaction *transaction,
                                              NSString *hashTransaction,
                                              QTUMBigNumber *estimatedFee)) completion {
    
    NSMutableArray *param = @[].mutableCopy;
    for (int i = 0; i < inputs.count; i++) {
        [param addObject:inputs[i].value];
    }
    
    NSArray<NSString *> *addressWithTokensValue = @[fromAddress];
    
    NSData *hashFuction = [SLocator.contractInterfaceManager hashOfFunction:item appendingParam:param];
    
    [SLocator.transactionManager callContractWithAddress:[NSString dataFromHexString:contract.contractAddress]
                                              andBitcode:hashFuction
                                                  amount:amount
                                           fromAddresses:addressWithTokensValue
                                               toAddress:nil
                                              walletKeys:SLocator.walletManager.wallet.allKeys
                                                     fee:fee
                                                gasPrice:gasPrice
                                                gasLimit:gasLimit
                                              andHandler:^(TransactionManagerErrorType errorType, BTCTransaction *transaction, NSString *hashTransaction, QTUMBigNumber *estimatedFee) {
                                                  
                                                  completion(errorType, transaction, hashTransaction, estimatedFee);
                                              }];
}


-(void)queryContractFunctionWithItem:(AbiinterfaceItem *) item
                            andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                            andToken:(Contract *) contract
                          andHandler:(QueryFunctionHandler) completion {
    
    if (self.queryProcessing) {
        return;
    }
    
    NSMutableArray *param = @[].mutableCopy;
    for (int i = 0; i < inputs.count; i++) {
        [param addObject:inputs[i].value];
    }
    
    NSData *hashFuction = [SLocator.contractInterfaceManager hashOfFunction:item appendingParam:param];
    NSString* hashAsString = [NSString hexadecimalString:hashFuction];
    
    __weak __typeof(self) weakSelf = self;
    [SLocator.requestManager callFunctionToContractAddress:contract.contractAddress
                                              frommAddress:nil
                                                withHashes:@[hashAsString]
                                               withHandler:^(id responseObject) {
                                                   
                                                   if (![responseObject isKindOfClass:[NSError class]] && [responseObject[@"items"] isKindOfClass:[NSArray class]]) {
                                                       
                                                       for (NSDictionary *dict in responseObject[@"items"]) {
                                                           
                                                           NSString *output = dict[@"output"];
                                                           
                                                           NSArray *array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:item];
                                                           
                                                           NSString* resultString = @"";
                                                           for (int i = 0; i < array.count; i++) {
                                                               resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"%@",array[i]]];
                                                           }
                                                           completion(resultString, nil);
                                                       }
                                                   } else if ([responseObject isKindOfClass:[NSError class]]){
                                                       completion(nil, responseObject);
                                                   } else {
                                                       completion(nil, nil);
                                                   }
                                                   
                                                   weakSelf.queryProcessing = NO;
                                                }];
}







@end
