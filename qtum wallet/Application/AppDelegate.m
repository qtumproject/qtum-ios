//
//  AppDelegate.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "AppDelegate.h"
#import "ApplicationCoordinator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[ApplicationCoordinator sharedInstance] start];
    return YES;
}



@end
