//
//  WalletManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "WalletManager.h"
#import "FXKeychain.h"

NSString const *WALLETS_KEY = @"qtum_wallet_wallets_keys";

@interface WalletManager () <WalletDelegate>

@property (nonatomic) NSMutableArray *wallets;

@end

@implementation WalletManager

+ (instancetype)sharedInstance
{
    static WalletManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

#pragma mark - Public Methods

- (Wallet *)createNewWalletWithName:(NSString *)name pin:(NSString *)pin
{
    if (!self.wallets) self.wallets = [NSMutableArray new];
    
    Wallet *newWallet = [[Wallet alloc] initWithName:name pin:pin];
    newWallet.delegate = self;
    
    [self.wallets addObject:newWallet];
    [self save];
    
    return newWallet;
}

- (Wallet *)importWalletWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords countOfUsedKey:(NSInteger)countOfUsedKey
{
    if (!self.wallets) self.wallets = [NSMutableArray new];
    
    Wallet *newWallet = [[Wallet alloc] initWithName:name pin:pin seedWords:seedWords countOfUsedKey:countOfUsedKey];
    newWallet.delegate = self;
    
    [self.wallets addObject:newWallet];
    [self save];
    
    return newWallet;
}

- (void)removeWallet:(Wallet *)wallet
{
    [self.wallets removeObject:wallet];
    [self save];
}

- (NSArray *)getAllWallets
{
    return [NSArray arrayWithArray:self.wallets];
}

- (void)removeAllWallets
{
    [self.wallets removeAllObjects];
    [self save];
}

#pragma mark - WalletDelegate

- (void)walletDidChange:(id)wallet
{
    [self save];
}

#pragma mark - KeyChain

- (BOOL)save
{
    BOOL resultKeys = [[FXKeychain defaultKeychain] setObject:self.wallets forKey:WALLETS_KEY];

    return resultKeys;
}

- (void)load
{
    NSMutableArray *savedArrray = [[FXKeychain defaultKeychain] objectForKey:WALLETS_KEY];
    
    for (Wallet *wallet in savedArrray) {
        wallet.delegate = self;
    }
    
    self.wallets = savedArrray;
}

@end
