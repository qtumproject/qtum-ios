//
//  SocketManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConnectionStatus) {
    NotConnected,
    Connected,
    Connecting,
    Disconnected
};

@interface SocketManager : NSObject

@property (assign,nonatomic,readonly) ConnectionStatus status;

-(void)startWithHandler:(void(^)()) handler;
-(void)subscripeToUpdateAdresses:(NSArray*)addresses withCompletession:(void(^)(NSArray* data)) handler;
-(void)stoptWithHandler:(void(^)()) handler;


@end
