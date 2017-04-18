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
NSString const *TOKENS_KEY = @"qtum_token_tokens_keys";
NSString const *USER_PIN_KEY = @"PIN";

@interface WalletManager () <WalletDelegate, TokenDelegate>

@property (nonatomic, strong) NSMutableArray *wallets;
@property (nonatomic, strong) NSMutableArray<Token*> *tokens;
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

- (instancetype)initUniqueInstance {
    self = [super init];
    if (self != nil) {
        [self load];
        _requestManager = [AppSettings sharedInstance].isRPC ? [RPCRequestManager sharedInstance] : [RequestManager sharedInstance];
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

- (void)importWalletWithName:(NSString *)name
                         pin:(NSString *)pin
                   seedWords:(NSArray *)seedWords
          withSuccessHandler:(void(^)(Wallet *newWallet))success
           andFailureHandler:(void(^)())failure {
    
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

- (Wallet *)getCurrentWallet {
    return [self.wallets lastObject];
}

- (void)removeWallet:(Wallet *)wallet {
    [self.wallets removeObject:wallet];
    [self save];
}

- (NSArray *)getAllWallets {
    return [NSArray arrayWithArray:self.wallets];
}

- (BOOL)haveWallets {
    return self.wallets.count != 0;
}

- (void)removeAllWallets {
    
    [self.wallets removeAllObjects];
}

- (void)removeAllTokens{
    
    [self.tokens removeAllObjects];
}

-(void)clear{
    [self removePin];
    [self removeAllTokens];
    [self removeAllWallets];
    [self save];
}

#pragma mark - Private methods

- (void)registerWalletInNode:(Wallet *)wallet withSuccessHandler:(void(^)())success andFailureHandler:(void(^)())failure
{
    self.registerGroup = dispatch_group_create();
    
    __block BOOL isAllCompleted = YES;


    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < wallet.countOfUsedKeys; i++) {
        BTCKey *key = [wallet getKeyAtIndex:i];
        
        dispatch_group_enter(self.registerGroup);
        
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        NSLog(@"Enter -- > %@",keyString);

        [[WalletManager sharedInstance].requestManager registerKey:keyString identifier:wallet.getWorldsString new:YES withSuccessHandler:^(id responseObject) {
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

- (NSMutableArray<Token*>*)tokens {
    if (!_tokens) {
        _tokens = @[].mutableCopy;
    }
    return _tokens;
}

#pragma mark - WalletDelegate

- (void)walletDidChange:(id)wallet{
    [self save];
}

#pragma mark - TokenDelegate

- (void)tokenDidChange:(id)wallet{
    [self saveOnlyTokens];
}

#pragma mark - KeyChain

- (BOOL)save {
    
    BOOL isSavedWallets = [[FXKeychain defaultKeychain] setObject:self.wallets forKey:WALLETS_KEY];
    BOOL isSavedTokens = [[FXKeychain defaultKeychain] setObject:self.tokens forKey:TOKENS_KEY];

    return isSavedWallets && isSavedTokens;
}

- (BOOL)saveOnlyTokens{
    
    BOOL isSavedTokens = [[FXKeychain defaultKeychain] setObject:self.tokens forKey:TOKENS_KEY];
    
    return isSavedTokens;
}

- (void)load {
    
    NSMutableArray *savedWallets = [[[FXKeychain defaultKeychain] objectForKey:WALLETS_KEY] mutableCopy];
    NSMutableArray *savedTokens = [[[FXKeychain defaultKeychain] objectForKey:TOKENS_KEY] mutableCopy];

    for (Wallet *wallet in savedWallets) {
        wallet.delegate = self;
    }
    
    for (Token *token in savedTokens) {
        token.delegate = self;
    }
    
    self.wallets = savedWallets;
    self.tokens = savedTokens;
    
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

#pragma mark - Token

- (NSArray <Token*>*)gatAllTokens{
    
    return self.tokens;
}

- (void)addNewToken:(Token*) token{
    token.delegate = self;
    [self.tokens addObject:token];
}

#pragma mark - Addresses Observing

- (void)startObservingForAddresses{
    [self.requestManager startObservingAdresses:[[self getCurrentWallet] getAllKeysAdreeses]];
}

- (void)stopObservingForAddresses{
    [self.requestManager stopObservingAdresses:nil];
}

- (void)startObservingForTokens{
    for (Token * token in self.tokens) {
        [self.requestManager startObservingForToken:token withHandler:nil];
    }
}
//
//- (void)stopObservingForAddresses{
//    [self.requestManager stopObservingAdresses:nil];
//}

@end
