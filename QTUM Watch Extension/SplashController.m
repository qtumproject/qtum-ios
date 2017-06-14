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

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *walletButton;

@property (nonatomic) WatchWallet *wallet;

@end

@implementation SplashController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self.walletButton setEnabled:NO];
    [self.walletButton setTitle:@"Loading..."];
    [SessionManager sharedInstance].delegate = self;;
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

#pragma mark - SessionManagerDelegate

- (void)activationDidCompleteWithState:(WCSessionActivationState)activationState {
    if (activationState == WCSessionActivationStateActivated) {
        __weak typeof(self) weakSelf = self;
        [[SessionManager sharedInstance] getInformationForWalletScreenWithSize:[WKInterfaceDevice currentDevice].screenBounds.size.width replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
            
            WatchWallet *wallet = [[WatchWallet alloc] initWithDictionary:replyMessage];
            
            [weakSelf.walletButton setTitle:@"QTUM"];
            [weakSelf.walletButton setEnabled:YES];
            weakSelf.wallet = wallet;
            [weakSelf showWaller];
        } errorHandler:^(NSError * _Nonnull error) {
            NSLog(@"Error");
        }];
    }else{
        NSLog(@"Error activation");
    }
}

- (IBAction)showWaller {
    [self presentControllerWithName:@"WalletController" context:self.wallet];
}

@end
