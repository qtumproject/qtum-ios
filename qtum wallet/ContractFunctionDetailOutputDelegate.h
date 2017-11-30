//
//  ContractFunctionDetailOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiinterfaceItem.h"
#import "ResultTokenInputsModel.h"

@protocol ContractFunctionDetailOutputDelegate <NSObject>

@optional
- (void)didCallFunctionWithItem:(AbiinterfaceItem *) item
					   andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                      andAmount:(QTUMBigNumber *) amount
                    fromAddress:(NSString*) fromAddress
					   andToken:(Contract *) token
						 andFee:(QTUMBigNumber *) fee
					andGasPrice:(QTUMBigNumber *) gasPrice
					andGasLimit:(QTUMBigNumber *) gasLimit;

- (void)didQueryFunctionWithItem:(AbiinterfaceItem *) item
                        andParam:(NSArray<ResultTokenInputsModel *> *) inputs
                        andToken:(Contract *) token;

@end
