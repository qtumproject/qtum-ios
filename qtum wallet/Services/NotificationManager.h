//
//  RemoutNotificationManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationManager : NSObject <Clearable>

- (void)registerForRemoutNotifications;

- (void)clear;

- (void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken;

- (void)application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error;

- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo;

- (void)   application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult)) completionHandler;

- (void)createLocalNotificationWithString:(NSString *) text andIdentifire:(NSString *) identifire;

- (NSString *)token;

- (NSString *)prevToken;

@end
