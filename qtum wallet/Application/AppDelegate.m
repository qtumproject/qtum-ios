//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AppDelegate.h"
#import "Appearance.h"
#import "ContractFileManager.h"
#import "NotificationManager.h"
#import "OpenURLManager.h"
#import "iOSSessionManager.h"

@interface AppDelegate ()

@property (assign, nonatomic) BOOL aplicationCoordinatorStarted;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
    }
    
    [iOSSessionManager sharedInstance];
    [ContractFileManager sharedInstance];
    [[AppSettings sharedInstance] setup];
    [Appearance setUp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!self.aplicationCoordinatorStarted) {
            [[ApplicationCoordinator sharedInstance] start];
            self.aplicationCoordinatorStarted  = YES;
        }
    });

    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if (!self.aplicationCoordinatorStarted) {
        [[ApplicationCoordinator sharedInstance].openUrlManager launchFromUrl:url];
        self.aplicationCoordinatorStarted  = YES;
    }
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[PopUpsManager sharedInstance] dismissLoader];
    [[ApplicationCoordinator sharedInstance] startConfirmPinFlowWithHandler:nil];
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[ApplicationCoordinator sharedInstance].notificationManager application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

@end
