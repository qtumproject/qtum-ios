//
//  SocketManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SocketManager.h"
#import <SIOSocket/SIOSocket.h>

static NSString *BASE_URL = @"http://192.168.1.41:3000/";

@interface SocketManager ()

@property (strong, nonatomic) SIOSocket* currentSocket;
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
    [SIOSocket socketWithHost:BASE_URL reconnectAutomatically:YES attemptLimit:-1 withDelay:2 maximumDelay:5 timeout:400 response:^(SIOSocket *socket) {
        weakSelf.currentSocket = socket;
        weakSelf.currentSocket.onConnect = ^(){
            weakSelf.status = Connected;
            handler();
        };
    }];
}

-(void)subscripeToUpdateAdresses:(NSArray*)addresses withCompletession:(void(^)(NSArray* data)) handler{
    
//    [self.currentSocket emit:@"userConnectUpdate" args:@[@"quantumd/addressbalance",@[@"mh6LD7E5rHbgeTY1EuSf6b1fJKSjVzqaP8"]]];
    
    [self.currentSocket on:@"userList" callback:^(SIOParameterArray *args) {
        NSLog(@"Updated %@",args);
    }];
    
    [self.currentSocket on:@"userConnectUpdate" callback:^(SIOParameterArray *args) {
        NSLog(@"Updated %@",args);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.currentSocket emit:@"connectUser" args:@[@"mh6LD7E5rHbgeTY1EuSf6b1fJKSjVzqaP8"]];
    });


}

@end
