//
//  ContractInfoFacade.m
//  qtum wallet
//
//  Created by Никита Федоренко on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractInfoFacade.h"

@implementation ContractInfoFacade

-(NSArray <ContracBalancesObject*>*)arrayOfStingValuesOfTokenBalanceWithToken:(Contract*) token {
    
    NSArray* allAddressesArray = [SLocator.walletManager.wallet addressesInRightOrder];
    NSDictionary <NSString*,QTUMBigNumber*>* addressBalanceDictionary = token.addressBalanceDictionary;
    NSMutableArray *resultArray = @[].mutableCopy;
    
    for (int i = 0; i < allAddressesArray.count; i++) {
        
        ContracBalancesObject* object = [ContracBalancesObject new];
        NSString* address = allAddressesArray[i];
        object.addressString = address;
        object.longBalanceStringBalance = [addressBalanceDictionary[address] stringNumberWithPowerOfMinus10:token.decimals];
        object.shortBalanceStringBalance = [addressBalanceDictionary[address] shortFormatOfNumberWithPowerOfMinus10:token.decimals];
        [resultArray addObject:object];
    }

    return [resultArray copy];
}

@end
