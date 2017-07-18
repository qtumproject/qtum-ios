//
//  WalletManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"
#import "Requestable.h"
#import "Contract.h"
#import "Managerable.h"
#import "WalletManagerRequestAdapter.h"

extern NSString *const kWalletDidChange;

@interface WalletManager : NSObject <Managerable>

@property (nonatomic, readonly) NSMutableArray *wallets;
@property (strong ,nonatomic,readonly) WalletManagerRequestAdapter* requestAdapter;

- (void)createNewWalletWithName:(NSString *)name pin:(NSString *)pin withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)())failure;
- (void)importWalletWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)())failure;
- (void)removeWallet:(Wallet *)wallet;
- (void)removeAllWallets;
- (void)storePin:(NSString*) pin;
- (void)removePin;
- (BOOL)verifyPin:(NSString*) pin;
- (BOOL)isSignedIn;
- (BOOL)haveWallets;
- (Wallet *)currentWallet;
- (NSArray *)allWallets;
- (NSDictionary *)hashTableOfKeys;

- (void)clear;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
