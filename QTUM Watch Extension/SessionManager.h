//
//  SessionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WatchConnectivity/WatchConnectivity.h>

@class WatchWallet;

@protocol SessionManagerDelegate <NSObject>

@optional
- (void)didReceiveInfo:(nullable NSDictionary *) userInfo;

- (void)activationDidCompleteWithState:(WCSessionActivationState) activationState;

@end

@protocol SessionManagerMessageSender <NSObject>

- (void)sendGetQRCodeForSize:(NSInteger) width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *_Nonnull replyMessage)) replyHandler errorHandler:(nullable void (^)(NSError *_Nonnull error)) errorHandler;

- (void)getInformationForWalletScreenWithSize:(NSInteger) width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *_Nonnull replyMessage)) replyHandler errorHandler:(nullable void (^)(NSError *_Nonnull error)) errorHandler;

@end

@protocol SessionManagerProtocol <NSObject>

@property (nonatomic, weak, nullable) id <SessionManagerDelegate> delegate;

- (void)activate;

@end

@interface SessionManager : NSObject <SessionManagerMessageSender, SessionManagerProtocol>


@end
