//
//  SplashController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
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
    [SessionManager sharedInstance].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:@"applicationDidBecomeActive" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

#pragma mark - Private Methods 

-(void)getDataFromHostAppAndConfigSelf {
    __weak typeof(self) weakSelf = self;
    
    [self.walletButton setTitle:@"Loading..."];
    [[SessionManager sharedInstance] getInformationForWalletScreenWithSize:[WKInterfaceDevice currentDevice].screenBounds.size.width replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
        
        if (!replyMessage[@"error"]) {
            WatchWallet *wallet = [[WatchWallet alloc] initWithDictionary:replyMessage];
            
            [weakSelf.walletButton setTitle:@"QTUM"];
            [weakSelf.walletButton setEnabled:YES];
            weakSelf.wallet = wallet;
            [weakSelf showWaller];
        } else {
            [weakSelf.walletButton setTitle:@"No Wallet"];
            [weakSelf.walletButton setEnabled:NO];
        }
        
    } errorHandler:^(NSError * _Nonnull error) {
        [weakSelf.walletButton setTitle:@"Error, reload app"];
        [weakSelf.walletButton setEnabled:NO];
    }];
}

#pragma mark - App Notifications

-(void)applicationDidBecomeActive{
    [self dismissController];

    [self getDataFromHostAppAndConfigSelf];
}

#pragma mark - SessionManagerDelegate

- (void)activationDidCompleteWithState:(WCSessionActivationState)activationState {
    if (activationState == WCSessionActivationStateActivated) {
        [self getDataFromHostAppAndConfigSelf];
    }else{
        NSLog(@"Error activation");
    }
}

- (IBAction)showWaller {
    [self presentControllerWithName:@"WalletController" context:self.wallet];
}

@end
