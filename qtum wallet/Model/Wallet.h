//
//  Wallet.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 15.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Wallet;
@protocol WalletDelegate <NSObject>

- (void)walletDidChange:(Wallet *)wallet;

@end

@interface Wallet : NSObject

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin;
- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *pin;
@property (nonatomic, readonly, copy) NSArray *seedWords;
@property (nonatomic, readonly) NSInteger countOfUsedKeys;

@property (nonatomic, weak) id<WalletDelegate> delegate;

- (BTCKey *)getLastRandomKeyOrRandomKey;
- (BTCKey *)getRandomKey;
- (BTCKey *)getKeyAtIndex:(NSUInteger)index;
- (NSArray *)getAllKeys;
- (NSString *)getWorldsString;

@end
