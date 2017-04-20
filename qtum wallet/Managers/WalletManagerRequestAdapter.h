//
//  WalletManagerRequestAdapter.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletManagerRequestAdapter : NSObject

- (void)getBalanceForAddreses:(NSArray *)keyAddreses withSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;
- (void)getHistoryForAddresses:(NSArray *)keyAddreses andParam:(NSDictionary*) param withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

@end