//
//  WatchCoordinator.h
//  QTUM Watch Extension
//
//  Created by Vladimir Lebedevich on 09.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WatchWallet;

typedef NS_ENUM(NSUInteger, WalletState) {
	NoWallet,
	WalletExists,
	Unknown
};

@protocol WatchDataProvider <NSObject>

@end

@interface WatchCoordinator : NSObject <WatchDataProvider>

@property (strong, nonatomic, readonly) WatchWallet *wallet;
@property (assign, nonatomic, readonly) WalletState stateOfWallet;

- (void)startDeamon;

- (void)startDeamonWithImmediatelyUpdate;

- (void)stopDeamon;

- (void)startWithCompletion:(void (^)(void)) completion;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
