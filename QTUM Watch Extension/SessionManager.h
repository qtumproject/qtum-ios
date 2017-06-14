//
//  SessionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@protocol SessionManagerDelegate <NSObject>

- (void)activationDidCompleteWithState:(WCSessionActivationState)activationState;

@end

@interface SessionManager : NSObject

+ (instancetype _Nonnull )sharedInstance;

- (id _Nonnull )init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype _Nonnull )alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype _Nonnull ) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)sendGetQRCodeForSize:(NSInteger)width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> * _Nonnull replyMessage))replyHandler errorHandler:(nullable void (^)(NSError * _Nonnull error))errorHandler;
- (void)getInformationForWalletScreenWithSize:(NSInteger)width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> * _Nonnull replyMessage))replyHandler errorHandler:(nullable void (^)(NSError * _Nonnull error))errorHandler;

@property (nonatomic, weak) id<SessionManagerDelegate> delegate;

@end
