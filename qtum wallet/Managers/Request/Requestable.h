//
//  Requestable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManagerAdapter.h"

@protocol Requestable <NSObject>

@required
@property (strong,nonatomic) id <RequestManagerAdapter> adapter;

+ (instancetype)sharedInstance;

// Key

- (void)registerKey:(NSString *)keyString
         identifier:(NSString *)identifier new:(BOOL)new
 withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)registerKey:(NSString *)keyString
                new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

// Transaction

- (void)sendTransactionWithParam:(NSDictionary *)param
              withSuccessHandler:(void(^)(id responseObject))success
               andFailureHandler:(void(^)(NSString* message)) failure;

//

- (void)getUnspentOutputsForAdreses:(NSArray*) addresses
                         isAdaptive:(BOOL) adaptive
                     successHandler:(void(^)(id responseObject))success
                  andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

// History

- (void)getHistoryWithParam:(NSDictionary*) param
               andAddresses:(NSArray*) addresses
             successHandler:(void(^)(id responseObject))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

// Some RPC help methods

- (void)getInfoWithSuccessHandler:(void(^)(id responseObject))success
                andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

- (void)sendToAddress:(NSString *)key
   withSuccessHandler:(void(^)(id responseObject))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)generate:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

// News

- (void)getNews:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

// Info

- (void)getBlockchainInfo:(void(^)(id responseObject))success
        andFailureHandler:(void(^)(NSError * error, NSString* message))failure;



@end
