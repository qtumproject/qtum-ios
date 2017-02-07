//
//  RPCRequestManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPCRequestManager : NSObject

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

// Key

- (void)registerKey:(NSString *)keyString identifier:(NSString *)identifier new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;
- (void)registerKey:(NSString *)keyString new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

// Transaction

- (void)getListUnspentForKeys:(NSArray *)keys withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;
- (void)sendTransaction:(NSString *)transactionHexString withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;

// History

- (void)getHistory:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

// Some RPC help methods

- (void)getInfoWithSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure;
- (void)sendToAddress:(NSString *)key withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;
- (void)generate:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;



@end
