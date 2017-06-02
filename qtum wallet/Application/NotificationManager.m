//
//  RemoutNotificationManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NotificationManager.h"
#import <UserNotifications/UserNotifications.h>

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface NotificationManager () <UNUserNotificationCenterDelegate,UIApplicationDelegate>

@end

static NSString* deviceTokenKey = @"deviceTokenKey";

@implementation NotificationManager

- (void)registerForRemoutNotifications
{
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    } else {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}


-(void)removeToken{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:deviceTokenKey];
}

#pragma mark - UNUserNotificationCenterDelegate

//Called when a notification is delivered to a foreground app.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"User Info : %@",notification.request.content.userInfo);
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    NSLog(@"User Info : %@",response.notification.request.content.userInfo);
    completionHandler();
}

#pragma mark - AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    NSString * deviceTokenString = [[[[deviceToken description]
//                                      stringByReplacingOccurrencesOfString: @"<" withString: @""]
//                                     stringByReplacingOccurrencesOfString: @">" withString: @""]
//                                    stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults] setObject:[deviceToken description] forKey:deviceTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   // [[TCARequestManager sharedInstance] registForPushNotificationWithSuccessHandler:nil andFailureHandler:nil];
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

- (void)registerForPushNotifications
{
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"PUSH NOTIFICATION : %@", userInfo);
//    if (application.applicationState == UIApplicationStateActive) {
//        [[TCAPushNotificationManager sharedInstance] showPushNotificationWithUserInfo:userInfo];
//    }else{
//        [[TCAPushNotificationManager sharedInstance] pushVCByUserInfo:userInfo];
//    }
}

- (void)createLocalNotificationWithString:(NSString*) text andIdentifire:(NSString*)identifire{
    
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNMutableNotificationContent* content = [UNMutableNotificationContent new];
        content.title = @"Local Notification";
        content.subtitle = @"QTUM";
        content.body = text;
        
        UNTimeIntervalNotificationTrigger* triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:identifire content:content trigger:triger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        }];
    } else {
        UILocalNotification* notification = [UILocalNotification new];
        notification.alertBody = text;
        notification.alertTitle = @"Local Notification";
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


@end
