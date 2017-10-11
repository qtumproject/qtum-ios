//
//  ExtensionDelegate.m
//  QTUM Watch Extension
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ExtensionDelegate.h"
#import "WatchCoordinator.h"

@interface ExtensionDelegate ()


@end

@implementation ExtensionDelegate

- (void)applicationDidFinishLaunching {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[WatchCoordinator sharedInstance] startWithCompletion:^{
        [[WatchCoordinator sharedInstance] startDeamon];
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_time_t timeUp = dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(60 * NSEC_PER_SEC));

    dispatch_semaphore_wait(semaphore, timeUp);
}

- (void)applicationDidBecomeActive {
    [[WatchCoordinator sharedInstance] startDeamon];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationWillResignActive {
    
    [[WatchCoordinator sharedInstance] stopDeamon];
}


- (void)handleBackgroundTasks:(NSSet<WKRefreshBackgroundTask *> *)backgroundTasks {
    // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
    for (WKRefreshBackgroundTask * task in backgroundTasks) {
        // Check the Class of each task to decide how to process it
        if ([task isKindOfClass:[WKApplicationRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKApplicationRefreshBackgroundTask *backgroundTask = (WKApplicationRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else if ([task isKindOfClass:[WKSnapshotRefreshBackgroundTask class]]) {
            // Snapshot tasks have a unique completion call, make sure to set your expiration date
            WKSnapshotRefreshBackgroundTask *snapshotTask = (WKSnapshotRefreshBackgroundTask*)task;
            [snapshotTask setTaskCompletedWithDefaultStateRestored:YES estimatedSnapshotExpiration:[NSDate distantFuture] userInfo:nil];
        } else if ([task isKindOfClass:[WKWatchConnectivityRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKWatchConnectivityRefreshBackgroundTask *backgroundTask = (WKWatchConnectivityRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else if ([task isKindOfClass:[WKURLSessionRefreshBackgroundTask class]]) {
            // Be sure to complete the background task once you’re done.
            WKURLSessionRefreshBackgroundTask *backgroundTask = (WKURLSessionRefreshBackgroundTask*)task;
            [backgroundTask setTaskCompleted];
        } else {
            // make sure to complete unhandled task types
            [task setTaskCompleted];
        }
    }
}

@end
