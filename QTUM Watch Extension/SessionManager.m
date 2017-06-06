//
//  SessionManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SessionManager.h"
#import <WatchConnectivity/WatchConnectivity.h>

const NSString *MainMessageKey = @"message_key";
const NSString *GetQRCodeMessageKey = @"get_qr_code";

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
    
    if (self.currentState == WCSessionActivationStateActivated && [WCSession defaultSession].isReachable) {
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

#pragma mark - WCSessionDelegate

/** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
- (void)session:(WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error{
    self.currentState = activationState;
    NSLog(@"WCSession activationDidCompleteWithState :  %ld", (long)activationState);
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


/** -------------------------- Background Transfers ------------------------- */

/** Called on the delegate of the receiver. Will be called on startup if an applicationContext is available. */
- (void)session:(WCSession *)session didReceiveApplicationContext:(NSDictionary<NSString *, id> *)applicationContext{
    NSLog(@"didReceiveApplicationContext : applicationContext : %@", applicationContext);
}

/** Called on the sending side after the user info transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the user info finished. */
- (void)session:(WCSession * __nonnull)session didFinishUserInfoTransfer:(WCSessionUserInfoTransfer *)userInfoTransfer error:(nullable NSError *)error{
    NSLog(@"didFinishUserInfoTransfer : %@", userInfoTransfer);
}

/** Called on the delegate of the receiver. Will be called on startup if the user info finished transferring when the receiver was not running. */
- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *, id> *)userInfo{
    NSLog(@"didReceiveUserInfo : %@", userInfo);
}

/** Called on the sending side after the file transfer has successfully completed or failed with an error. Will be called on next launch if the sender was not running when the transfer finished. */
- (void)session:(WCSession *)session didFinishFileTransfer:(WCSessionFileTransfer *)fileTransfer error:(nullable NSError *)error{
    NSLog(@"didFinishFileTransfer : %@", fileTransfer);
}

/** Called on the delegate of the receiver. Will be called on startup if the file finished transferring when the receiver was not running. The incoming file will be located in the Documents/Inbox/ folder when being delivered. The receiver must take ownership of the file by moving it to another location. The system will remove any content that has not been moved when this delegate method returns. */
- (void)session:(WCSession *)session didReceiveFile:(WCSessionFile *)file{
    NSLog(@"didReceiveFile : %@", file);
}


@end
