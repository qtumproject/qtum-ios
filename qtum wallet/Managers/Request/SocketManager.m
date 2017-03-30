//
//  SocketManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SocketManager.h"
#import <SIOSocket/SIOSocket.h>
@import SocketIO;

static NSString *BASE_URL = @"http://163.172.68.103:5931/";

@interface SocketManager ()

@property (strong, nonatomic) SocketIOClient* currentSocket;
@property (assign,nonatomic) ConnectionStatus status;
@property (nonatomic, copy) void (^onUpdateAddresses)(NSArray*);


@end

@implementation SocketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)startWithHandler:(void(^)()) handler{
    __weak __typeof(self)weakSelf = self;
//    [SIOSocket socketWithHost:BASE_URL reconnectAutomatically:YES attemptLimit:-1 withDelay:2 maximumDelay:5 timeout:400 response:^(SIOSocket *socket) {
//        weakSelf.currentSocket = socket;
//        weakSelf.currentSocket.onConnect = ^(){
//            weakSelf.status = Connected;
//            handler();
//        };
//    }];
    
    NSURL* url = [[NSURL alloc] initWithString:BASE_URL];
    self.currentSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
    
    [self.currentSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        weakSelf.status = Connected;
        handler();
    }];

    
    [self.currentSocket connect];
}

-(void)subscripeToUpdateAdresses:(NSArray*)addresses withCompletession:(void(^)(NSArray* data)) handler{
    
//    [self.currentSocket emit:@"userConnectUpdate" args:@[@"quantumd/addressbalance",@[@"mh6LD7E5rHbgeTY1EuSf6b1fJKSjVzqaP8"]]];
    
    
    [self.currentSocket on:@"quantumd/test" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"%@",data);
    }];
    
    [self.currentSocket emit:@"subscribe" with:@[@"quantumd/addressbalance",addresses]];
    
    [self.currentSocket onAny:^(SocketAnyEvent * _Nonnull event) {
        NSLog(@"%@",event);
    }];
    [self.currentSocket on:@"quantumd/addressbalance" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"%@",data);
    }];

}

-(void)stoptWithHandler:(void(^)()) handler{
    [self.currentSocket disconnect];
}

@end
