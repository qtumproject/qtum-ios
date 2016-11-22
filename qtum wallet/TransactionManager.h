//
//  TransactionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionManager : NSObject

//- (instancetype) initWith:(BTCKey *)key andSendingValue:(NSNumber *)value toAddress:(NSString *)toAddress;
//- (instancetype) initWithSendingValue:(NSNumber *)value toAddress:(NSString *)toAddress;
- (instancetype) initWith:(NSArray *)amountsAndAddresses;

- (void)sendTransactionWithSuccess:(void(^)())success andFailure:(void(^)())failure;

@end
