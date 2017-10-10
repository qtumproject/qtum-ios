//
//  WatchCoordinator.m
//  QTUM Watch Extension
//
//  Created by Никита Федоренко on 09.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WatchCoordinator.h"
#import "SessionManager.h"
#import <WatchKit/WatchKit.h>
#import "WatchWallet.h"

@interface WatchCoordinator()

@property (strong, nonatomic) id <SessionManagerProtocol> sessionManager;
@property (strong, nonatomic) id <SessionManagerMessageSender> messageSender;
@property (strong, nonatomic) WatchWallet* wallet;
@property (strong, nonatomic) NSOperationQueue* operationQueue;
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
        _messageSender = manager;
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

-(void)startWithCompletion:(void(^)(void)) completion {
    
    [self.sessionManager activate];
    
    __weak typeof(self) weakSelf = self;

    self.startingCompletion = ^(void){
        completion();
        weakSelf.startingCompletion = nil;
    };
    
    [self startDeamonWithCompletion:self.startingCompletion];
}

-(void)startDeamonWithCompletion:(void(^)(void)) completion {
    
    __weak typeof(self) weakSelf = self;
    [self getWalletWithCompletion:^{
        
        if (completion) {
            completion();
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kWalletDidUpdate" object:nil];
        });
        
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC));
        
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [weakSelf startDeamonWithCompletion:nil];
        });
    }];
}

#pragma mark - Private Methods

-(void)getWalletWithCompletion:(void(^)(void)) completion {
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_block_t block = ^{
        
        [weakSelf.messageSender getInformationForWalletScreenWithSize:[WKInterfaceDevice currentDevice].screenBounds.size.width replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            
            if (!replyMessage[@"error"]) {
                
                WatchWallet *wallet = [[WatchWallet alloc] initWithDictionary:replyMessage];
                weakSelf.wallet = wallet;
                
                if (completion) {
                    completion();
                }

            } else {
                
                [weakSelf getWalletWithCompletion:[completion copy]];
            }
            
        } errorHandler:^(NSError * _Nonnull error) {
            
            [weakSelf getWalletWithCompletion:[completion copy]];
        }];
    };

    [self.operationQueue addOperationWithBlock:block];
}

@end
