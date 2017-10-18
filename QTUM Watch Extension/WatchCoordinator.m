//
//  WatchCoordinator.m
//  QTUM Watch Extension
//
//  Created by Vladimir Lebedevich on 09.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WatchCoordinator.h"
#import "SessionManager.h"
#import <WatchKit/WatchKit.h>
#import "WatchWallet.h"
#import "WatchDataOperation.h"

@interface WatchCoordinator() <SessionManagerDelegate>

@property (strong, nonatomic) id <SessionManagerProtocol> sessionManager;
@property (strong, nonatomic) id <SessionManagerMessageSender> messageSender;
@property (strong, nonatomic) WatchWallet* wallet;
@property (strong, nonatomic) NSOperationQueue* operationQueue;
@property (strong, nonatomic) dispatch_queue_t deamonQueue;
@property (strong, nonatomic) NSTimer* loopTimer;


@property (copy, nonatomic) void(^startingCompletion)(void);

@end

@implementation WatchCoordinator

+ (instancetype)sharedInstance {
    
    static WatchCoordinator *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super alloc] initUniqueInstance];
    });
    return manager;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        
        SessionManager* manager = [SessionManager new];
        _sessionManager = manager;
        _sessionManager.delegate = self;
        _messageSender = manager;
        _operationQueue = [[NSOperationQueue alloc] init];
        _deamonQueue = dispatch_queue_create("org.qtum.deamonQueue", DISPATCH_QUEUE_SERIAL);
        [self configWallet];
    }
    
    return self;
}

-(void)configWallet {
    
    NSDictionary* info = [WatchDataOperation getWalletInfo];
    
    if (info) {
        _wallet = [[WatchWallet alloc] initWithDictionary:info];
    }
}

-(void)startWithCompletion:(void(^)(void)) completion {
    
    [self.sessionManager activate];
    
    __weak typeof(self) weakSelf = self;

    self.startingCompletion = ^(void){
        completion();
        weakSelf.startingCompletion = nil;
    };
    
    [self getWalletWithCompletion:^{
        
        if (self.startingCompletion) {
            self.startingCompletion();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWalletDidUpdate" object:nil];
        });
    }];
}

-(void)startDeamon {

    [self startTimerForAnotherLoop];
}

-(void)startDeamonWithImmediatelyUpdate {
    
    [self updateWalletInfo];
}

-(void)startTimerForAnotherLoop {
    
    __weak typeof(self) weakSelf = self;

    dispatch_sync(_deamonQueue, ^{
        
        if (weakSelf.loopTimer) {
            [weakSelf.loopTimer invalidate];
            weakSelf.loopTimer = nil;
        }
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:15
                                                 target:self
                                               selector:@selector(updateWalletInfo)
                                               userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        weakSelf.loopTimer = timer;
    });
}

-(void)updateWalletInfo {
    
    __weak typeof(self) weakSelf = self;

    [self getWalletWithCompletion:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWalletDidUpdate" object:nil];
        });
        
        [weakSelf startTimerForAnotherLoop];
    }];
}

-(void)stopDeamon {
    
    [_operationQueue cancelAllOperations];
    
    if (self.loopTimer) {
        [self.loopTimer invalidate];
        self.loopTimer = nil;
    }
}

#pragma mark - Private Methods

-(void)getWalletWithCompletion:(void(^)(void)) completion {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t block = ^{
        
        [weakSelf.messageSender getInformationForWalletScreenWithSize:[WKInterfaceDevice currentDevice].screenBounds.size.width replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            
            if (!replyMessage[@"error"]) {
                
                WatchWallet *wallet = [[WatchWallet alloc] initWithDictionary:replyMessage];
                [WatchDataOperation saveWalletInfo:replyMessage];
                weakSelf.wallet = wallet;

            } else {
                
                weakSelf.wallet = nil;
                [WatchDataOperation saveWalletInfo:nil];
            }
            
            if (completion) {
                completion();
            }
            
        } errorHandler:^(NSError * _Nonnull error) {
            
            [weakSelf getWalletWithCompletion:[completion copy]];
        }];
    };

    [self.operationQueue addOperationWithBlock:block];
}

#pragma mark - SessionManagerDelegate

-(void)didReceiveInfo:(NSDictionary *)userInfo {
    
    [WatchDataOperation saveWalletInfo:userInfo];
}

@end
