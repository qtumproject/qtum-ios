//
//  WalletManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "WalletManager.h"
#import "FXKeychain.h"
#import "RPCRequestManager.h"

NSString const *WALLETS_KEY = @"qtum_wallet_wallets_keys";
NSString const *USER_PIN_KEY = @"PIN";

@interface WalletManager () <WalletDelegate>

@property (nonatomic) NSMutableArray *wallets;
@property (nonatomic) NSString* PIN;

@property (nonatomic) dispatch_group_t registerGroup;

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
        _requestManager = [RPCRequestManager sharedInstance];
    }
    return self;
}

#pragma mark - Public Methods

- (void)createNewWalletWithName:(NSString *)name pin:(NSString *)pin withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)())failure
{
    if (!self.wallets) self.wallets = [NSMutableArray new];
    
    Wallet *newWallet = [[Wallet alloc] initWithName:name pin:pin];
    newWallet.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [self registerWalletInNode:newWallet withSuccessHandler:^{
        [weakSelf.wallets addObject:newWallet];
        [weakSelf save];
        success(newWallet);
    } andFailureHandler:^{
        failure();
    }];
}

- (void)importWalletWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)())failure
{
    if (!self.wallets) self.wallets = [NSMutableArray new];
    
    Wallet *newWallet = [[Wallet alloc] initWithName:name pin:pin seedWords:seedWords];
    if (!newWallet){
        failure();
        return;
    }
    newWallet.delegate = self;
    
    __weak typeof(self) weakSelf = self;
    [self registerWalletInNode:newWallet withSuccessHandler:^{
        [weakSelf.wallets addObject:newWallet];
        [weakSelf save];
        success(newWallet);
    } andFailureHandler:^{
        failure();
    }];
}

- (Wallet *)getCurrentWallet
{
    return [self.wallets lastObject];
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

- (BOOL)haveWallets
{
    return self.wallets.count != 0;
}

- (void)removeAllWallets
{
    [self.wallets removeAllObjects];
    [self save];
}

#pragma mark - Private methods

// Only for RPC
- (void)registerWalletInNode:(Wallet *)wallet withSuccessHandler:(void(^)())success andFailureHandler:(void(^)())failure
{
    self.registerGroup = dispatch_group_create();
    
    __block BOOL isAllCompleted = YES;


    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < wallet.countOfUsedKeys; i++) {
        BTCKey *key = [wallet getKeyAtIndex:i];
        
        dispatch_group_enter(self.registerGroup);
        NSLog(@"Enter -- > %@",key.address.string);
        [[WalletManager sharedInstance].requestManager registerKey:key.address.string identifier:wallet.getWorldsString new:YES withSuccessHandler:^(id responseObject) {
            dispatch_group_leave(weakSelf.registerGroup);
            NSLog(@"Success");
        } andFailureHandler:^(NSError *error, NSString *message) {
            isAllCompleted = NO;
            dispatch_group_leave(weakSelf.registerGroup);
            NSLog(@"Fail");
        }];
    }
    
    dispatch_group_notify(self.registerGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"All comleted");
            if (isAllCompleted) {
                success();
            }else {
                failure();
            }
        });
    });
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
    NSMutableArray *savedArrray = [[[FXKeychain defaultKeychain] objectForKey:WALLETS_KEY] mutableCopy];
    
    for (Wallet *wallet in savedArrray) {
        wallet.delegate = self;
    }
    
    self.wallets = savedArrray;
    
    self.PIN = [[FXKeychain defaultKeychain] objectForKey:USER_PIN_KEY];
}

-(void)storePin:(NSString*) pin {
    if ([[FXKeychain defaultKeychain] objectForKey:USER_PIN_KEY]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:USER_PIN_KEY];
    }
    [[FXKeychain defaultKeychain] setObject:pin forKey:USER_PIN_KEY];
    self.PIN = pin;
}

- (void)removePin
{
    [[FXKeychain defaultKeychain] removeObjectForKey:USER_PIN_KEY];
    self.PIN = nil;
}

@end
