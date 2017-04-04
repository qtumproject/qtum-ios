//
//  SocketManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SocketManager.h"
#import <SIOSocket/SIOSocket.h>
#import "BlockchainInfoManager.h"
@import SocketIO;

static NSString *BASE_URL = @"http://163.172.68.103:5931/";

@interface SocketManager ()

@property (strong, nonatomic) SocketIOClient* currentSocket;
@property (assign,nonatomic) ConnectionStatus status;
@property (nonatomic, copy) void (^onUpdateAddresses)(NSArray*);
@property (nonatomic, copy) void (^startCallback)();



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
    
    self.startCallback = handler;
    NSURL* url = [[NSURL alloc] initWithString:BASE_URL];
    self.currentSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
    
    [self.currentSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        weakSelf.status = Connected;
        if (weakSelf.startCallback) {
            weakSelf.startCallback();
            weakSelf.startCallback = nil;
        }
    }];
    
    [self.currentSocket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        weakSelf.status = Disconnected;
    }];

    [self.currentSocket connect];
}

-(void)subscripeToUpdateAdresses:(NSArray*)addresses withCompletession:(void(^)(NSArray* data)) handler{
    
    [self.currentSocket onAny:^(SocketAnyEvent * _Nonnull event) {
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:[NSString stringWithFormat:@"any event - > %@",event.event] andIdentifire:@"onAny"];
    }];
    
    [self.currentSocket on:@"balance_changed" callback:^(NSArray* data, SocketAckEmitter* ack) {

        NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");

        [BlockchainInfoManager updateBalance:[self.delegate.adapter adaptiveDataForBalance:[data[0][@"balance"] floatValue]]];
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Balance Changed" andIdentifire:@"balance_changed"];
    }];
    
    [self.currentSocket on:@"new_transaction" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
        [BlockchainInfoManager addHistoryElementWithDict:(NSDictionary*)data[0]];
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"New Transaction" andIdentifire:@"new_transaction"];
    }];
    
    [self.currentSocket emit:@"subscribe" with:@[@"balance_subscribe",addresses]];
}

-(void)stoptWithHandler:(void(^)()) handler{
    [self.currentSocket disconnect];
}

@end
