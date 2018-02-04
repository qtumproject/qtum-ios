//
//  WalletManagerRequestAdapter.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletManagerRequestAdapter : NSObject

- (void)getBalanceForAddreses:(NSArray *) keyAddreses withSuccessHandler:(void (^)(QTUMBigNumber *balance)) success andFailureHandler:(void (^)(NSError *error, NSString *message)) failure;

- (void)getunspentOutputs:(NSArray *) keyAddreses withSuccessHandler:(void (^)(NSArray *responseObject)) success andFailureHandler:(void (^)(NSError *error, NSString *message)) failure;

- (HistoryElement *)createHistoryElement:(NSDictionary *) dictionary;

@end
