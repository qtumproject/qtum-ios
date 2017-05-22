//
//  RemoutNotificationManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationManager : NSObject

- (void)registerForRemoutNotifications;
- (void)removeToken;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)createLocalNotificationWithString:(NSString*) text andIdentifire:(NSString*)identifire;

@end
