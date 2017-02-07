//
//  TCARequestManager.h
//  TCA2016
//
//  Created by Nikita on 09.08.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TCAAuthFailed;


@interface RequestManager : NSObject

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

//Methods
- (void)getBalanceByKey:(NSString *)publicKey withSuccessHandler:(void(^)(id responseObject)) success andFailureHandler:(void(^)(NSString* message)) failure;
- (void)sendTransaction:(NSDictionary *)dictionary withSuccessHandler:(void(^)(id responseObject)) success andFailureHandler:(void(^)(NSString* message)) failure;

//Get History
- (void)getHistory:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

//Get News
- (void)getNews:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure;



@end
