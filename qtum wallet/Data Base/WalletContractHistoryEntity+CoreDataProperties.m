//
//  WalletContractHistoryEntity+CoreDataProperties.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "WalletContractHistoryEntity+CoreDataProperties.h"

@implementation WalletContractHistoryEntity (CoreDataProperties)

+ (NSFetchRequest<WalletContractHistoryEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WalletContractHistoryEntity"];
}

@dynamic amountString;
@dynamic contractAddress;
@dynamic fromAddresses;
@dynamic toAddresses;
@dynamic transactionHash;
@dynamic txTime;
@dynamic dateInerval;
@dynamic hasReceipt;
@dynamic currency;
@dynamic confirmed;
@dynamic contracted;
@dynamic decimalString;
@dynamic internal;
@dynamic send;

@end
