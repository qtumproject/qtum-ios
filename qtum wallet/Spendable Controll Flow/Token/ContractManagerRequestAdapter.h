//
//  ContractManagerRequestAdapter.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractManagerRequestAdapter : NSObject

- (void)getHistoryForTokenAddress:(NSString *) tokenAddress
                         andParam:(NSDictionary *) param
                            token:(Contract *) token
               withSuccessHandler:(void (^)(NSArray *responseObject)) success
                andFailureHandler:(void (^)(NSError *error, NSString *message)) failure;

@end
