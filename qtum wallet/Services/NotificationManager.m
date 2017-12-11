//
//  RemoutNotificationManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "NSUserDefaults+Settings.h"
@import Firebase;

NSString *const FireBaseInfoFileName = @"GoogleService-Info";

@interface NotificationManager () <UNUserNotificationCenterDelegate, UIApplicationDelegate, FIRMessagingDelegate>

@end

@implementation NotificationManager

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForRemoutNotifications {

	if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
		UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
		center.delegate = self;
		[center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError *_Nullable error) {
			if (!error) {
				dispatch_async (dispatch_get_main_queue (), ^{
					[[UIApplication sharedApplication] registerForRemoteNotifications];
				});
			}
		}];
	} else {
		[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[[UIApplication sharedApplication] registerForRemoteNotifications];
	}

	NSString *path = [[NSBundle mainBundle] pathForResource:FireBaseInfoFileName ofType:@"plist"];
	NSDictionary *dictPri = [NSDictionary dictionaryWithContentsOfFile:path];
    
	if (dictPri) {
        FIROptions* option = [[FIROptions alloc] initWithContentsOfFile:path];
		[FIRApp configureWithOptions:option];
        [FIRMessaging messaging].shouldEstablishDirectChannel = YES;
        [FIRMessaging messaging].delegate = self;
	}
}

- (void)clear {

	[self removeToken];
}

- (void)removeToken {
	[NSUserDefaults saveDeviceToken:nil];
}

- (NSString *)token {
	return [NSUserDefaults getDeviceToken];
}

- (NSString *)prevToken {
	return [NSUserDefaults getPrevDeviceToken];
}

#pragma mark - UNUserNotificationCenterDelegate

//Called when a notification is delivered to a foreground app.
- (void)userNotificationCenter:(UNUserNotificationCenter *) center willPresentNotification:(UNNotification *) notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options)) completionHandler {
	DLog(@"User Info : %@", notification.request.content.userInfo);
	completionHandler (UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
}

//Called to let your app know which action was selected by the user for a given notification.
- (void)userNotificationCenter:(UNUserNotificationCenter *) center didReceiveNotificationResponse:(UNNotificationResponse *) response withCompletionHandler:(void (^)(void)) completionHandler {
	DLog(@"User Info : %@", response.notification.request.content.userInfo);
	completionHandler ();
}

#pragma mark - AppDelegate

- (void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {

    [[FIRMessaging messaging] setAPNSToken:deviceToken type:FIRMessagingAPNSTokenTypeSandbox];
}

- (void)registerForPushNotifications {

	[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
	[[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo {

	DLog(@"PUSH NOTIFICATION : %@", userInfo);
}

- (void)application:(UIApplication *) application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
	DLog(@"didFailToRegisterForRemoteNotificationsWithError : %@", error);
}

- (void)   application:(UIApplication *) application didReceiveRemoteNotification:(NSDictionary *) userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult)) completionHandler {

	[[FIRMessaging messaging] appDidReceiveMessage:userInfo];
}

#pragma mark - Private Methods

- (void)storeDeviceToken:(NSString*) token {

	NSString *prevToken = [NSUserDefaults getDeviceToken];
	[NSUserDefaults saveDeviceToken:token];
	[NSUserDefaults savePrevDeviceToken:([prevToken isEqualToString:token]) ? @"" : prevToken];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)createLocalNotificationWithString:(NSString *) text andIdentifire:(NSString *) identifire {

	if (SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {

		UNMutableNotificationContent *content = [UNMutableNotificationContent new];
		content.subtitle = NSLocalizedString(@"QTUM", nil);
		content.body = text;

		UNTimeIntervalNotificationTrigger *triger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
		UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifire content:content trigger:triger];
		[[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
	} else {
		UILocalNotification *notification = [UILocalNotification new];
		notification.alertBody = text;
		notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
		[[UIApplication sharedApplication] scheduleLocalNotification:notification];
	}
}

- (void)messaging:(nonnull FIRMessaging *)messaging didReceiveRegistrationToken:(nonnull NSString *)fcmToken {
    
    __weak __typeof (self) weakSelf = self;

    dispatch_async (dispatch_get_main_queue (), ^{
        [weakSelf storeDeviceToken:fcmToken];
        [SLocator.walletManager startObservingForAllSpendable];
        [SLocator.contractManager startObservingForAllSpendable];
    });
}


@end
