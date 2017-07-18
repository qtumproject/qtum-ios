//
//  WalletManagering.h
//  qtum wallet
//
//  Created by Никита Федоренко on 18.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Managerable.h"
#import "Clearable.h"

@class Wallet;
@class WalletManagerRequestAdapter;

@protocol WalletManagering <Clearable, Managerable>

@property (strong ,nonatomic,readonly) WalletManagerRequestAdapter* requestAdapter;
@property (strong ,nonatomic) Wallet* wallet;

- (void)createNewWalletWithName:(NSString *)name
                            pin:(NSString *)pin
             withSuccessHandler:(void(^)(Wallet *newWallet))success
              andFailureHandler:(void(^)())failure;

- (void)createNewWalletWithName:(NSString *)name
                            pin:(NSString *)pin seedWords:(NSArray *)seedWords
             withSuccessHandler:(void(^)(Wallet *newWallet))success
              andFailureHandler:(void(^)())failure;

- (void)storePin:(NSString*) pin;
- (BOOL)verifyPin:(NSString*) pin;
- (BOOL)isSignedIn;
- (NSDictionary *)hashTableOfKeys;
- (BOOL)startWithPin:(NSString*) pin;
- (NSString*)brandKeyWithPin:(NSString*) pin;

@end
