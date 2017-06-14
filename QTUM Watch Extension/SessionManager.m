//
//  SessionManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SessionManager.h"

const NSString *MainMessageKey = @"message_key";
const NSString *GetQRCodeMessageKey = @"get_qr_code";
const NSString *GetWalletInformation = @"get_wallet_information";

@interface SessionManager() <WCSessionDelegate>

@property (nonatomic) WCSessionActivationState currentState;

@end

@implementation SessionManager

+ (instancetype)sharedInstance
{
    static SessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super alloc] initUniqueInstance];
    });
    return manager;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    
    if (self != nil) {
        if ([WCSession isSupported]) {
            WCSession *session = [WCSession defaultSession];
            session.delegate = self;
            [session activateSession];
            NSLog(@"WCSession is supported");
        }else{
            NSLog(@"WCSession is NOT supported");
        }
    }
    
    return self;
}

- (void)sendMessage:(NSDictionary *)dictionary replyHandler:(nullable void (^)(NSDictionary<NSString *, id> *replyMessage))replyHandler errorHandler:(nullable void (^)(NSError *error))errorHandler{
    //&& [WCSession defaultSession].isReachable
    if (self.currentState == WCSessionActivationStateActivated ) {
        WCSession *session = [WCSession defaultSession];
        [session sendMessage:dictionary replyHandler:replyHandler errorHandler:errorHandler];
    }else{
        NSError *error = [[NSError alloc] init];
        errorHandler(error);
    }
}

- (void)sendGetQRCodeForSize:(NSInteger)width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> * _Nonnull replyMessage))replyHandler errorHandler:(nullable void (^)(NSError * _Nonnull error))errorHandler{
    
    NSDictionary *dictionary = @{MainMessageKey : GetQRCodeMessageKey,
                                 @"width" : @(width)};
    
    [self sendMessage:dictionary replyHandler:replyHandler errorHandler:errorHandler];
}

- (void)getInformationForWalletScreenWithSize:(NSInteger)width replyHandler:(nullable void (^)(NSDictionary<NSString *, id> * _Nonnull replyMessage))replyHandler errorHandler:(nullable void (^)(NSError * _Nonnull error))errorHandler {
    NSDictionary *dictionary = @{MainMessageKey : GetWalletInformation,
                                 @"width" : @(width)};
    
    [self sendMessage:dictionary replyHandler:replyHandler errorHandler:errorHandler];
}

#pragma mark - WCSessionDelegate

/** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error{
    NSLog(@"WCSession activationDidCompleteWithState :  %ld", (long)activationState);
    self.currentState = activationState;
    
    if ([self.delegate respondsToSelector:@selector(activationDidCompleteWithState:)]) {
        [self.delegate activationDidCompleteWithState:self.currentState];
    }
}

/** ------------------------- iOS App State For Watch ------------------------ */

/** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
- (void)sessionDidBecomeInactive:(WCSession *)session{
    self.currentState = session.activationState;
    NSLog(@"sessionDidBecomeInactive");
}

/** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
- (void)sessionDidDeactivate:(WCSession *)session{
    self.currentState = session.activationState;
    NSLog(@"sessionDidDeactivate");
}

/** Called when any of the Watch state properties change. */
- (void)sessionWatchStateDidChange:(WCSession *)session{
    self.currentState = session.activationState;
    NSLog(@"sessionWatchStateDidChange : state = %ld", (long)session.activationState);
}

/** ------------------------- Interactive Messaging ------------------------- */

/** Called when the reachable state of the counterpart app changes. The receiver should check the reachable property on receiving this delegate callback. */
- (void)sessionReachabilityDidChange:(WCSession *)session{
    NSLog(@"sessionReachabilityDidChange");
}

/** Called on the delegate of the receiver. Will be called on startup if the incoming message caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message{
    NSLog(@"sessionReachabilityDidChange : message : %@", message);
}

/** Called on the delegate of the receiver when the sender sends a message that expects a reply. Will be called on startup if the incoming message caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    NSLog(@"didReceiveMessage with reply : message : %@", message);
}

/** Called on the delegate of the receiver. Will be called on startup if the incoming message data caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData{
    NSLog(@"didReceiveMessage with reply : data : %@", messageData);
}

/** Called on the delegate of the receiver when the sender sends message data that expects a reply. Will be called on startup if the incoming message data caused the receiver to launch. */
- (void)session:(WCSession *)session didReceiveMessageData:(NSData *)messageData replyHandler:(void(^)(NSData *replyMessageData))replyHandler{
    NSLog(@"didReceiveMessage with reply : data : %@", messageData);
}


@end
