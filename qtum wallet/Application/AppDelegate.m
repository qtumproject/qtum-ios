//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AppDelegate.h"
#import "RPCRequestManager.h"
#import "Appearance.h"
#import "ContractManager.h"
#import "ContractArgumentsInterpretator.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     Remove all wallets
//    [[WalletManager sharedInstance] removeAllWallets];
    
    [Appearance setUp];
    [[AppSettings sharedInstance] setup];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[ApplicationCoordinator sharedInstance] start];
    });

//     Send money for our wallet
//    if ([[WalletManager sharedInstance] haveWallets]) {
//        [[WalletManager sharedInstance].requestManager sendToAddress:[[[WalletManager sharedInstance] getCurrentWallet] getRandomKey].address.string withSuccessHandler:^(id responseObject) {
//            NSLog(@"yes");
//        } andFailureHandler:^(NSError *error, NSString *message) {
//            NSLog(@"no");
//        }];
//    }
//
    [ContractArgumentsInterpretator contactArgumentsFromArray:nil];
    return YES;
}

- (NSArray *)getRandomWordsFromWordsArray:(NSInteger)count
{
    NSMutableArray *randomWords = @[].mutableCopy;
    NSInteger i = 0;
    
    while (i < count) {
        uint32_t rnd = arc4random_uniform((uint32_t)wordsArray().count);
        NSString *randomWord = wordsArray()[rnd];
        
        if (![randomWords containsObject:randomWord]) {
            [randomWords addObject:randomWord];
            i++;
        }
    }
    
    return randomWords;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    [[ApplicationCoordinator sharedInstance] launchFromUrl:url];
    return YES;
}

#pragma mark - Notifications


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[ApplicationCoordinator sharedInstance].notificationManager application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[ApplicationCoordinator sharedInstance].notificationManager application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[ApplicationCoordinator sharedInstance].notificationManager application:application didReceiveRemoteNotification:userInfo];
}



@end
