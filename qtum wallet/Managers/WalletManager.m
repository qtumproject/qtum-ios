//
//  WalletManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "WalletManager.h"
#import "FXKeychain.h"
#import "WalletManagerRequestAdapter.h"
#import "SocketManager.h"
#import "NSString+SHA3.h"
#import "NSNumber+Comparison.h"
#import "iOSSessionManager.h"

NSString const *kWallets = @"qtum_wallet_wallets_keys";
NSString const *kSingleWallet = @"qtum_wallet_wallet_keys";
NSString *const kWalletDidChange = @"kWalletDidChange";
NSString *const kWalletHistoryDidChange = @"kWalletHistoryDidChange";
NSString const *kUserPin = @"PIN";
NSString const *kUserPinHash = @"HashPIN";
NSString const *kIsLongPin = @"kIsLongPin";

@interface WalletManager ()

@property (nonatomic, strong) NSString* hashOfPin;
@property (nonatomic, strong) dispatch_group_t registerGroup;
@property (strong ,nonatomic) WalletManagerRequestAdapter* requestAdapter;
@property (assign, nonatomic) BOOL observingForSpendableFailed;
@property (assign, nonatomic) BOOL observingForSpendableStopped;

@end

@implementation WalletManager

@synthesize wallet;

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self load];
        
        _requestAdapter = [WalletManagerRequestAdapter new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didContinieObservingForSpendable)
                                                     name:kSocketDidConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didForceStopObservingForSpendable)
                                                     name:kSocketDidDisconnect object:nil];
    }
    
    return self;
}

#pragma mark - WalletManagering

- (void)createNewWalletWithName:(NSString *)name pin:(NSString *)pin withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)(void))failure {
        
    Wallet *newWallet = [SLocator.walletsFactory createNewWalletWithName:name pin:pin];
    newWallet.manager = self;
    [newWallet loadToMemory];
    self.wallet = newWallet;
    [self save];
    
    if (newWallet) {
        success(newWallet);
    } else {
        failure();
    }
}

- (void)createNewWalletWithName:(NSString *)name
                            pin:(NSString *)pin
                      seedWords:(NSArray *)seedWords
             withSuccessHandler:(void(^)(Wallet *newWallet))success
              andFailureHandler:(void(^)(void))failure {
    
    Wallet *newWallet = [SLocator.walletsFactory createNewWalletWithName:name pin:pin seedWords:seedWords];
    
    newWallet.manager = self;
    [newWallet loadToMemory];
    
    self.wallet = newWallet;
    [self save];
    
    if (newWallet) {
        success(newWallet);
    } else {
        failure();
    }
}

- (NSDictionary *)hashTableOfKeys {
    
    NSMutableDictionary *hashTable = [NSMutableDictionary new];
    for (BTCKey *key in [[self wallet] allKeys]) {
        NSString* keyString = SLocator.appSettings.isMainNet ? key.address.string : key.addressTestnet.string;
        if (keyString) {
            hashTable[keyString] = [NSNull null];
        }
    }
    return [hashTable copy];
}

- (NSDictionary *)hashTableOfKeysForHistoryElement {
    
    NSMutableDictionary *hashTable = [NSMutableDictionary new];
    for (NSString *keyString in [[self wallet] allKeysAdreeses]) {
        if (keyString) {
            hashTable[keyString] = [NSNull null];
        }
    }
    return [hashTable copy];
}

-(void)clear {
    
    [self removePin];
    [self.wallet clearPublicAddresses];
    self.wallet = nil;
    [self save];
}

#pragma mark - Observing

-(void)didContinieObservingForSpendable {
    
    if (self.observingForSpendableFailed && !self.observingForSpendableStopped) {
        [self startObservingForAllSpendable];
        [self updateHistoryOfSpendableObject:self.wallet withHandler:nil andPage:0];
    }
    self.observingForSpendableFailed = NO;
}

-(void)didForceStopObservingForSpendable {
    
    self.observingForSpendableFailed = YES;
}


#pragma mark - WalletDelegate

- (void)walletDidChange:(id)wallet {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWalletDidChange object:nil userInfo:nil];
    [SLocator.iOSSessionManager updateWatch];
    [self save];
}

- (void)walletHistoryDidChange:(id)wallet {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kWalletHistoryDidChange object:nil userInfo:nil];
    [self save];
}

#pragma mark - KeyChain

- (BOOL)save {
    
    BOOL isSavedWallet = [[FXKeychain defaultKeychain] setObject:self.wallet forKey:kSingleWallet];
    return isSavedWallet;
}

- (void)load {

    [self migrateData];
    
    Wallet *storedWallet = [[FXKeychain defaultKeychain] objectForKey:kSingleWallet];
    
    if (storedWallet && [storedWallet isKindOfClass:[Wallet class]]) {
        storedWallet.manager = self;
        [storedWallet loadToMemory];
    }

    wallet = storedWallet;
    _hashOfPin = [[FXKeychain defaultKeychain] objectForKey:kUserPinHash];
}

-(void)migrateData {
    
    NSArray* storedWallets = [[FXKeychain defaultKeychain] objectForKey:kWallets];
    NSString* userPin = [[FXKeychain defaultKeychain] objectForKey:kUserPin];
    
    if (storedWallets.count > 0 && [storedWallets.firstObject isKindOfClass:[Wallet class]] && userPin) {
        
        Wallet* storedWallet = storedWallets.firstObject;
        Wallet* rebuildWallet = nil;

        if (storedWallet.seedWords) {
            rebuildWallet = [[Wallet alloc] initWithName:storedWallet.name pin:userPin seedWords:storedWallet.seedWords];
        }
        [[FXKeychain defaultKeychain] setObject:rebuildWallet forKey:kSingleWallet];
        [[FXKeychain defaultKeychain] removeObjectForKey:kWallets];
    }
    
    if (userPin) {
        [self storePin:userPin];
    }
}

-(void)storePin:(NSString*) pin {
    
    NSString* hashOfPin = [pin sha3:SHA3256];
    
    if (hashOfPin) {
        
        [self saveHashOPin:hashOfPin andPin:pin];
    }
}

-(BOOL)changePinFrom:(NSString*) pin toPin:(NSString*) newPin{
    
    NSString* hashOfPin = [newPin sha3:SHA3256];
    
    if ([self.wallet changeBrandKeyPinWithOldPin:pin toNewPin:newPin] && hashOfPin) {
        
        [self saveHashOPin:hashOfPin andPin:newPin];
        return YES;
    }
    
    return NO;
}

-(void)saveHashOPin:(NSString*) hashOfPin andPin:(NSString*) pin{
    
    [[FXKeychain defaultKeychain] setObject:hashOfPin forKey:kUserPinHash];
    [[FXKeychain defaultKeychain] addTouchIdString:pin];
    [[FXKeychain defaultKeychain] setObject:pin.length > 4 ? @(YES) : @(NO) forKey:kIsLongPin];

    self.hashOfPin = hashOfPin;
    [self save];
}


- (void)removePin {
    
    [[FXKeychain defaultKeychain] removeObjectForKey:kUserPinHash];
    [[FXKeychain defaultKeychain] removeObjectForKey:kIsLongPin];
    self.hashOfPin = nil;
}

- (BOOL)verifyPin:(NSString*) pin {
    
    return [[pin sha3:SHA3256] isEqualToString:self.hashOfPin];
}

- (BOOL)isSignedIn {
    
    return self.wallet && self.hashOfPin;
}

- (BOOL)isLongPin {
    
    return [[[FXKeychain defaultKeychain] objectForKey:kIsLongPin] boolValue];
}


- (BOOL)startWithPin:(NSString*) pin {
    
    return [self.wallet configAddressesWithPin:pin];
}

- (NSString*)brandKeyWithPin:(NSString*) pin {
    
    return [self.wallet brandKeyWithPin:pin];
}


#pragma mark - Managerable

-(void)startObservingForSpendable:(id <Spendable>) spendable {
}

-(void)stopObservingForSpendable:(id <Spendable>) spendable {
}

-(void)startObservingForAllSpendable {
    
    self.observingForSpendableStopped = NO;
    [SLocator.requestManager startObservingAdresses:[self.wallet allKeysAdreeses]];
}

-(void)stopObservingForAllSpendable {
    
    self.observingForSpendableStopped = YES;
    [SLocator.requestManager stopObservingAdresses:nil];
}

#pragma mark - Addresses Observing

-(void)updateSpendableObject:(id <Spendable>) object{
    
}

-(void)updateBalanceOfSpendableObject:(Wallet <Spendable>*) object withHandler:(void(^)(BOOL success)) complete{
    
    [self.requestAdapter getBalanceForAddreses:[object allKeysAdreeses] withSuccessHandler:^(NSDecimalNumber* balance) {
        
        object.balance = balance;
        complete(YES);
    } andFailureHandler:^(NSError *error, NSString *message) {
        complete(NO);
    }];
}

-(void)updateHistoryOfSpendableObject:(Wallet <Spendable>*) object withHandler:(void(^)(BOOL success)) complete andPage:(NSInteger) page{

    static NSInteger batch = 25;
    [self.requestAdapter getHistoryForAddresses:[object allKeysAdreeses] andParam:@{@"limit" : @(batch), @"offset" : @(page * batch)} withSuccessHandler:^(NSArray <HistoryElement*> *history) {
        
        if (page > object.historyStorage.pageIndex) {
            [object.historyStorage addHistoryElements:history];
        } else {
            [object.historyStorage setHistory:history];
        }
        object.historyStorage.pageIndex = page;
        if (complete) {
            complete(YES);
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        
        if (complete) {
            complete(NO);
        }
    }];
}

-(void)loadSpendableObjects{
    
    [self load];
}

-(void)saveSpendableObjects{
    
    [self save];
}

-(void)updateSpendablesBalansesWithObject:(NSDictionary*) balances {
    
    NSNumber* balance = balances[@"balance"];
    NSNumber* unconfirmedBalance = balances[@"unconfirmedBalance"];
    
    if ([balance isKindOfClass:[NSNumber class]]) {
        self.wallet.balance = [balance decimalNumber];
    }
    
    if ([unconfirmedBalance isKindOfClass:[NSNumber class]]) {
        self.wallet.unconfirmedBalance = [unconfirmedBalance decimalNumber];
    }

    [self spendableDidChange:self.wallet];
}

-(void)updateSpendablesHistoriesWithObject:(NSDictionary*) dict {
    
    HistoryElement* item = [self.requestAdapter createHistoryElement:dict];
    [self.wallet.historyStorage setHistoryItem:item];
}

-(void)historyOfSpendableDidChange:(id <Spendable>) object {
    
    [self walletHistoryDidChange:object];
}

-(void)spendableDidChange:(id <Spendable>) object {
    
    [self walletDidChange:object];
}

@end
