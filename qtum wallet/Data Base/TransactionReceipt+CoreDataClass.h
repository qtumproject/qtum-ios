//
//  TransactionReceipt+CoreDataClass.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Log;

NS_ASSUME_NONNULL_BEGIN

@interface TransactionReceipt : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "TransactionReceipt+CoreDataProperties.h"
