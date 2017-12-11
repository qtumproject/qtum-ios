//
//  ContractInfoFacade.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContracBalancesObject.h"

@interface ContractInfoFacade : NSObject

- (NSArray <ContracBalancesObject *> *)arrayOfStingValuesOfTokenBalanceWithToken:(Contract *) token;
- (NSArray <ContracBalancesObject *> *)sortedArrayOfStingValuesOfTokenBalanceWithToken:(Contract *) token;

@end
