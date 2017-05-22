//
//  AppSettings.h
//  qtum wallet
//
//  Created by Никита Федоренко on 24.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

@property (assign, nonatomic, readonly) BOOL isMainNet;
@property (assign, nonatomic, readonly) BOOL isRPC;


-(void)setup;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
