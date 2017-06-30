//
//  WalletManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "WalletManager.h"
#import "FXKeychain.h"
#import "RPCRequestManager.h"
#import "WalletManagerRequestAdapter.h"
#import "HistoryDataStorage.h"

NSString const *kWalletKey = @"qtum_wallet_wallets_keys";
NSString const *kUserPin = @"PIN";
NSString *const kWalletDidChange = @"kWalletDidChange";

@interface WalletManager ()

@property (nonatomic, strong) NSMutableArray *wallets;
@property (nonatomic, strong) NSString* PIN;
@property (nonatomic, strong) dispatch_group_t registerGroup;
@property (strong ,nonatomic) WalletManagerRequestAdapter* requestAdapter;

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
        _requestAdapter = [WalletManagerRequestAdapter new];
    }
    return self;
}

#pragma mark - Lazy Getters

-(NSMutableArray*)wallets {
    
    if (!_wallets) {
        _wallets = @[].mutableCopy;
    }
    return _wallets;
}



#pragma mark - Public Methods

- (void)createNewWalletWithName:(NSString *)name pin:(NSString *)pin withSuccessHandler:(void(^)(Wallet *newWallet))success andFailureHandler:(void(^)())failure {
        
    Wallet *newWallet = [[WalletsFactory sharedInstance] createNewWalletWithName:name pin:pin];
    newWallet.manager = self;
    [newWallet loadToMemory];
    
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
    
    Wallet *newWallet = [[WalletsFactory sharedInstance] createNewWalletWithName:name pin:pin seedWords:seedWords];
    
    if (!newWallet){
        failure();
        return;
    }
    newWallet.manager = self;
    [newWallet loadToMemory];
    
    __weak typeof(self) weakSelf = self;
    [self registerWalletInNode:newWallet withSuccessHandler:^{
        [weakSelf.wallets addObject:newWallet];
        [weakSelf save];
        success(newWallet);
    } andFailureHandler:^{
        failure();
    }];
}

- (Wallet *)сurrentWallet {
    
    return [self.wallets firstObject];
}

- (NSDictionary *)hashTableOfKeys{
    NSMutableDictionary *hashTable = [NSMutableDictionary new];
    for (BTCKey *key in [[self сurrentWallet] allKeys]) {
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        if (keyString) {
            hashTable[keyString] = [NSNull null];
        }
    }
    return [hashTable copy];
}

- (void)removeWallet:(Wallet *)wallet {
    
    [self.wallets removeObject:wallet];
    [self save];
}

- (NSArray *)allWallets {
    
    return [NSArray arrayWithArray:self.wallets];
}

- (BOOL)haveWallets {
    
    return self.wallets.count != 0;
}

- (void)removeAllWallets {
    
    [self.wallets removeAllObjects];
}

-(void)clear{
    
    [self removePin];
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
        BTCKey *key = [wallet keyAtIndex:i];
        
        dispatch_group_enter(self.registerGroup);
        
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        NSLog(@"Enter -- > %@",keyString);

        [[ApplicationCoordinator sharedInstance].requestManager registerKey:keyString identifier:wallet.worldsString new:YES withSuccessHandler:^(id responseObject) {
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

- (void)walletDidChange:(id)wallet{
    [[NSNotificationCenter defaultCenter] postNotificationName:kWalletDidChange object:nil userInfo:nil];
    [self save];
}

#pragma mark - KeyChain

- (BOOL)save {
    
    BOOL isSavedWallets = [[FXKeychain defaultKeychain] setObject:self.wallets forKey:kWalletKey];
    return isSavedWallets;
}

- (void)load {
    
    NSMutableArray *savedWallets = [[[FXKeychain defaultKeychain] objectForKey:kWalletKey] mutableCopy];

    for (Wallet *wallet in savedWallets) {
        wallet.manager = self;
        [wallet loadToMemory];
    }

    self.wallets = savedWallets;
    self.PIN = [[FXKeychain defaultKeychain] objectForKey:kUserPin];
}

-(void)storePin:(NSString*) pin {
    
    if ([[FXKeychain defaultKeychain] objectForKey:kUserPin]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:kUserPin];
    }
    [[FXKeychain defaultKeychain] setObject:pin forKey:kUserPin];
    self.PIN = pin;
}

- (void)removePin {
    
    [[FXKeychain defaultKeychain] removeObjectForKey:kUserPin];
    self.PIN = nil;
}

#pragma mark - Managerable

-(void)startObservingForSpendable:(id <Spendable>) spendable {
}

-(void)stopObservingForSpendable:(id <Spendable>) spendable {
}

-(void)startObservingForAllSpendable {
    [[ApplicationCoordinator sharedInstance].requestManager startObservingAdresses:[[self сurrentWallet] allKeysAdreeses]];
}

-(void)stopObservingForAllSpendable {
    [[ApplicationCoordinator sharedInstance].requestManager stopObservingAdresses:nil];
}

#pragma mark - Addresses Observing

-(void)updateSpendableObject:(id <Spendable>) object{
    
}

-(void)updateBalanceOfSpendableObject:(Wallet <Spendable>*) object withHandler:(void(^)(BOOL success)) complete{
    
    // __weak __typeof(self)weakSelf = self;
    [self.requestAdapter getBalanceForAddreses:[object allKeysAdreeses] withSuccessHandler:^(double balance) {
        
        object.balance = balance;
        complete(YES);
    } andFailureHandler:^(NSError *error, NSString *message) {
        complete(NO);
    }];
}

-(void)updateHistoryOfSpendableObject:(Wallet <Spendable>*) object withHandler:(void(^)(BOOL success)) complete andPage:(NSInteger) page{
    //__weak __typeof(self)weakSelf = self;
    static NSInteger batch = 10;
    [self.requestAdapter getHistoryForAddresses:[object allKeysAdreeses] andParam:@{@"limit" : @(batch), @"offset" : @(page * batch)} withSuccessHandler:^(NSArray <HistoryElement*> *history) {
        
        if (page > object.historyStorage.pageIndex) {
            [object.historyStorage addHistoryElements:history];
        } else {
            [object.historyStorage setHistory:history];
        }
        object.historyStorage.pageIndex = page;
        complete(YES);
    } andFailureHandler:^(NSError *error, NSString *message) {
        
        complete(NO);
    }];
}

-(void)loadSpendableObjects{
    
    [self load];
}

-(void)saveSpendableObjects{
    
    [self save];
}

-(void)updateSpendablesBalansesWithObject:(NSDictionary*) balances{
    [self сurrentWallet].balance = [balances[@"balance"] floatValue];
    [self сurrentWallet].unconfirmedBalance = [balances[@"unconfirmedBalance"] floatValue];
    [self spendableDidChange:[self сurrentWallet]];
}

-(void)updateSpendablesHistoriesWithObject:(NSDictionary*) dict{
    HistoryElement* item = [self.requestAdapter createHistoryElement:dict];
    [[self сurrentWallet].historyStorage setHistoryItem:item];
}

-(void)spendableDidChange:(id <Spendable>) object{
    [self walletDidChange:object];
}

@end
