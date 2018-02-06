//
//  TransactionReceipt+CoreDataProperties.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "TransactionReceipt+CoreDataProperties.h"

@implementation TransactionReceipt (CoreDataProperties)

+ (NSFetchRequest<TransactionReceipt *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TransactionReceipt"];
}

@dynamic blockHash;
@dynamic blockNumber;
@dynamic contractAddress;
@dynamic cumulativeGasUsed;
@dynamic from;
@dynamic gasUsed;
@dynamic to;
@dynamic transactionHash;
@dynamic transactionIndex;
@dynamic logs;

@end
