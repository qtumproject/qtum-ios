//
//  WalletBalanceEntity+CoreDataProperties.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "WalletBalanceEntity+CoreDataProperties.h"

@implementation WalletBalanceEntity (CoreDataProperties)

+ (NSFetchRequest<WalletBalanceEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WalletBalanceEntity"];
}

@dynamic balanceString;
@dynamic dateInterval;
@dynamic unconfirmedBalanceString;

@end
