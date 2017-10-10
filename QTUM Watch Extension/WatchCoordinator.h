//
//  WatchCoordinator.h
//  QTUM Watch Extension
//
//  Created by Никита Федоренко on 09.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WatchWallet;

@protocol WatchDataProvider <NSObject>

@end

@interface WatchCoordinator : NSObject <WatchDataProvider>

@property (strong, nonatomic, readonly) WatchWallet* wallet;

-(void)startWithCompletion:(void(^)(void)) completion;
-(void)startDeamonWithCompletion:(void(^)(void)) completion;

-(void)stopDeamon;
-(void)pauseDeamon;
-(void)countinieDeamon;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
