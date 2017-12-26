//
//  CallContractFacadeService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CreateContractHandler)(TransactionManagerErrorType errorType,
                                     BTCTransaction *transaction,
                                     NSString *hashTransaction,
                                     QTUMBigNumber *estimatedValue);

typedef void(^CallFunctionHandler)(TransactionManagerErrorType errorType,
                                   BTCTransaction *transaction,
                                   NSString *hashTransaction,
                                   QTUMBigNumber *estimatedFee);

typedef void(^QueryFunctionHandler)(NSString* result,
                                    NSError *error);

typedef void(^ExistingContractHandler)(BOOL exist,
                                    NSError *error);

@interface CallContractFacadeService : NSObject

- (void)createSmartContractWithTemplate:(NSString *) templatePath
                               andArray:(NSArray *) args
                                    fee:(QTUMBigNumber *) fee
                               gasPrice:(QTUMBigNumber *) gasPrice
                               gasLimit:(QTUMBigNumber *) gasLimit
                             andHandler:(CreateContractHandler) completion;

-(void)callContractFunctionWithItem:(AbiinterfaceItem *) item
                             andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                            andAmount:(QTUMBigNumber*) amount
                            fromAddress:(NSString*) fromAddress
                             andToken:(Contract *) contract
                               andFee:(QTUMBigNumber *) fee
                          andGasPrice:(QTUMBigNumber *) gasPrice
                          andGasLimit:(QTUMBigNumber *) gasLimit
                        andHandler:(CallFunctionHandler) completion;

-(void)queryContractFunctionWithItem:(AbiinterfaceItem *) item
                            andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                            andToken:(Contract *) contract
                          andHandler:(QueryFunctionHandler) completion;

-(void)checkContractWithAddress:(NSString *) contractAddress
                     andHandler:(ExistingContractHandler) completion;

@end
