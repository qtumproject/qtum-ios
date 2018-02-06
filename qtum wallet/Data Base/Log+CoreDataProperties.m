//
//  Log+CoreDataProperties.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "Log+CoreDataProperties.h"

@implementation Log (CoreDataProperties)

+ (NSFetchRequest<Log *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Log"];
}

@dynamic address;
@dynamic data;
@dynamic topics;

@end
