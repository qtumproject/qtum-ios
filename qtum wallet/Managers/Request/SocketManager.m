//
//  SocketManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SocketManager.h"
#import "ApplicationCoordinator.h"
#import "NotificationManager.h"

@import SocketIO;

static NSString *BASE_URL = @"http://163.172.68.103:5931/";

@interface SocketManager ()

@property (strong, nonatomic) SocketIOClient* currentSocket;
@property (assign,nonatomic) ConnectionStatus status;
@property (nonatomic, copy) void (^onConnected)();
@property (assign, nonatomic) BOOL isAlreadyInit;
@property (nonatomic, strong) NSOperationQueue* requestQueue;


@end

@implementation SocketManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)startAndSubscribeWithAddresses:(NSArray*) addresses andHandler:(void(^)()) handler {
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_block_t block = ^{
        NSURL* url = [[NSURL alloc] initWithString:BASE_URL];
        weakSelf.currentSocket = [[SocketIOClient alloc] initWithSocketURL:url config:@{@"log": @YES, @"forcePolling": @YES}];
        weakSelf.onConnected = handler;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        [self.currentSocket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            weakSelf.status = Connected;
            if (!weakSelf.isAlreadyInit) {
                [weakSelf subscribeToEvents];
                weakSelf.isAlreadyInit = YES;
            }
            dispatch_semaphore_signal(semaphore);
            weakSelf.onConnected();
            [weakSelf subscripeToUpdateAdresses:addresses withCompletession:nil];
        }];
        
        [self.currentSocket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            weakSelf.status = Disconnected;
        }];
        
        [weakSelf.currentSocket connect];
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    };
    
    [_requestQueue addOperationWithBlock:block];
}

-(void)subscripeToUpdateAdresses:(NSArray*)addresses withCompletession:(void(^)(NSArray* data)) handler {
    
    NSString* token  = [[ApplicationCoordinator sharedInstance].notificationManager token];
    NSString* prevToken  = [[ApplicationCoordinator sharedInstance].notificationManager prevToken];

    [self.currentSocket emit:@"subscribe" with:@[@"balance_subscribe",addresses, @{@"notificationToken" : token ?: [NSNull null],
                                                                                   @"prevToken" : prevToken ?: [NSNull null],
                                                                                   @"language" : [LanguageManager currentLanguageCode]}]];
}

-(void)subscribeToEvents {
    [self.currentSocket on:@"balance_changed" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
        [[WalletManager sharedInstance] updateSpendablesBalansesWithObject:[self.delegate.adapter adaptiveDataForBalance:data[0]]];
    }];
    
    [self.currentSocket on:@"new_transaction" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSAssert([data isKindOfClass:[NSArray class]], @"result must be an array");
        [[WalletManager sharedInstance] updateSpendablesHistoriesWithObject:(NSDictionary*)data[0]];
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"New Transaction" andIdentifire:@"new_transaction"];
    }];
    
    [self.currentSocket on:@"token_balance_change" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        [[ContractManager sharedInstance] updateTokenWithContractAddress:data[0][@"contract_address"] withAddressBalanceDictionary:data[0]];
    }];
}

-(void)stoptWithHandler:(void(^)()) handler {
    NSString* token  = [[ApplicationCoordinator sharedInstance].notificationManager token];
    [self.currentSocket emit:@"unsubscribe" with:@[@"balance_subscribe",[NSNull null], @{@"notificationToken" : token ?: [NSNull null]}]];
    [self.currentSocket emit:@"unsubscribe" with:@[@"token_balance_change",[NSNull null], @{@"notificationToken" : token ?: [NSNull null]}]];

    [self.currentSocket disconnect];
}

-(void)startObservingToken:(Contract*) token withHandler:(void(^)()) handler{
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(Contract*)weakToken = token;
    NSString* deviceToken  = [[ApplicationCoordinator sharedInstance].notificationManager token];
    NSString* prevToken  = [[ApplicationCoordinator sharedInstance].notificationManager prevToken];
    dispatch_block_t block = ^{
        if (weakToken) {
            [weakSelf.currentSocket emit:@"subscribe" with:@[@"token_balance_change",@{@"contract_address" : weakToken.contractAddress, @"addresses" : [[[WalletManager sharedInstance] hashTableOfKeys] allKeys]}, @{@"notificationToken" : deviceToken ?: [NSNull null],
                                                                                                                                                                                                                         @"prevToken" : prevToken ?: [NSNull null],
                                                                                                                                                                                                                         @"language" : [LanguageManager currentLanguageCode]}]];
        }
    };
    [_requestQueue addOperationWithBlock:block];
}

-(void)stopObservingToken:(Contract*) token withHandler:(void(^)()) handler {
    
    __weak __typeof(self)weakSelf = self;
    __weak __typeof(Contract*)weakToken = token;
    NSString* deviceToken  = [[ApplicationCoordinator sharedInstance].notificationManager token];
    dispatch_block_t block = ^{
        if (weakToken) {
            [weakSelf.currentSocket emit:@"unsubscribe" with:@[@"token_balance_change",@{@"contract_address" : weakToken.contractAddress, @"addresses" : [[[WalletManager sharedInstance] hashTableOfKeys] allKeys]}, @{@"notificationToken" : deviceToken ?: @""}]];
        }
    };
    [_requestQueue addOperationWithBlock:block];
}


@end
