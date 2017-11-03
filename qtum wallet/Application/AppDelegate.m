//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AppDelegate.h"
#import "Appearance.h"
#import "ContractFileManager.h"
#import "NotificationManager.h"
#import "OpenURLManager.h"
#import "iOSSessionManager.h"

#import "QStoreDataProvider.h"
#import "ServiceLocator.h"
#import "NewsDataProvider.h"
#import "BTCBigNumber.h"
#import "NSNumber+Format.h"

@interface AppDelegate ()

@property (assign, nonatomic) BOOL aplicationCoordinatorStarted;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [iOSSessionManager sharedInstance];
    [ServiceLocator sharedInstance];
    [[AppSettings sharedInstance] setup];
    [Appearance setUp];

    [[ApplicationCoordinator sharedInstance] startSplashScreen];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        if (!self.aplicationCoordinatorStarted) {
            [[ApplicationCoordinator sharedInstance] start];
            self.aplicationCoordinatorStarted  = YES;
        }
    });
    
//    NSLog(@"start");
//    BTCMutableBigNumber* number = [[BTCMutableBigNumber alloc] initWithDecimalString:@"2"];
//    BTCBigNumber* number2 = [[BTCBigNumber alloc] initWithDecimalString:@"115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936115792089237316195423570985008687907853269984665640564039457584007913129639936"];
//    BTCBigNumber* number3 = [number exp:number2];
//    NSLog(@"finish");
//
   
    QTUMBigNumber* numberQ = [[QTUMBigNumber alloc] initWithString:@"40.04"];
    QTUMBigNumber* power = [[QTUMBigNumber alloc] initWithString:@"1"];

    NSString* shortStringQ = [numberQ shortFormatOfNumberWithPowerOfMinus10:power];
    
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    [[ApplicationCoordinator sharedInstance].openUrlManager launchFromUrl:url];
    self.aplicationCoordinatorStarted  = YES;
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
