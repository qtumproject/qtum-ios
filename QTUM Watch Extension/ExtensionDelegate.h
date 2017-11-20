//
//  ExtensionDelegate.h
//  QTUM Watch Extension
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <WatchKit/WatchKit.h>

@protocol ExtensionDelegateDelegate <NSObject>

- (void)applicationDidFinishLaunching;

- (void)applicationDidBecomeActive;

- (void)applicationWillResignActive;

@end

@interface ExtensionDelegate : NSObject <WKExtensionDelegate>

@end
