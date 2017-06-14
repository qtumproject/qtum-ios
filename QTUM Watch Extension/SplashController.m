//
//  SplashController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SplashController.h"
#import "SessionManager.h"
#import "WatchWallet.h"
#import "WalletController.h"

@interface SplashController() <SessionManagerDelegate>

@end

@implementation SplashController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [SessionManager sharedInstance].delegate = self;;
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - SessionManagerDelegate

- (void)activationDidCompleteWithState:(WCSessionActivationState)activationState {
    if (activationState == WCSessionActivationStateActivated) {
        __weak typeof(self) weakSelf = self;
        [[SessionManager sharedInstance] getInformationForWalletScreenWithReplyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            WatchWallet *wallet = [[WatchWallet alloc] initWithDictionary:replyMessage];
            [weakSelf showWalletScreen:wallet];
        } errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"Error");
        }];
    }else{
        NSLog(@"Error activation");
    }
}

- (void)showWalletScreen:(WatchWallet *)wallet {
    [self presentControllerWithName:@"WalletController" context:wallet];
}

@end
