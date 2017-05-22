//
//  SocketManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

typedef NS_ENUM(NSInteger, ConnectionStatus) {
    NotConnected,
    Connected,
    Connecting,
    Disconnected
};

@interface SocketManager : NSObject

@property (assign,nonatomic,readonly) ConnectionStatus status;
@property (nonatomic, weak) id <Requestable> delegate;


-(void)startAndSubscribeWithAddresses:(NSArray*) addresses andHandler:(void(^)()) handler;
-(void)stoptWithHandler:(void(^)()) handler;

-(void)startObservingToken:(Token*) token withHandler:(void(^)()) handler;


@end
