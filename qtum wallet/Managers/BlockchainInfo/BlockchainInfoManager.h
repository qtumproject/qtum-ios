//
//  BalanceManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

@interface BlockchainInfoManager : NSObject

// Balance
+ (void)getBalanceForAddreses:(NSArray *)keyAddreses withSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;
+ (void)getBalanceForAllAddresesWithSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

// Outputs
+ (void)getunspentOutputs:(NSArray *)keyAddreses withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

// History
+ (void)getHistoryForAddresses:(NSArray *)keyAddreses andParam:(NSDictionary*) param withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;
+ (void)getHistoryForAllAddresesWithSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
                                          andParam:(NSDictionary*) param;
+ (void)addHistoryElementWithDict:(NSDictionary*) dict;
// Balance
+ (void)updateBalance:(CGFloat) balance;

// Convert
+ (BTCAmount)convertValueToAmount:(double)value;

//Keys

+ (NSDictionary *)getHashTableOfKeys;

@end
