//
//  WalletBalancesObject.h
//  qtum wallet
//
//  Created by Никита Федоренко on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletBalancesObject : NSObject

@property (copy, nonatomic) NSString* shortBalanceStringBalance;
@property (copy, nonatomic) NSString* longBalanceStringBalance;
@property (copy, nonatomic) NSString* addressString;

@end
