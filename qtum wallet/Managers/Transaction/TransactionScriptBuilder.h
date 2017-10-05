//
//  TransactionScriptBuilder.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionScriptBuilder : NSObject

-(BTCScript*)createContractScriptWithBiteCode:(NSData*) bitcode
                                  andGasLimit:(NSDecimalNumber*) aGasLimit
                                  andGasPrice:(NSDecimalNumber*) aGasPrice;

-(BTCScript*)sendContractScriptWithBiteCode:(NSData*) bitcode
                         andContractAddress:(NSData*) address
                                andGasLimit:(NSDecimalNumber*) aGasLimit
                                andGasPrice:(NSDecimalNumber*) aGasPrice;

@end
