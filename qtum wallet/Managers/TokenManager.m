//
//  TokenManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 12.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenManager.h"
#import "HistoryElement.h"
#import "FXKeychain.h"
#import "Token.h"

NSString const *kTokenKeys = @"qtum_token_tokens_keys";
NSString *const kTokenDidChange = @"kTokenDidChange";

static NSString* kSmartContractPretendentsKey = @"smartContractPretendentsKey";

@interface TokenManager () <TokenDelegate>

@property (strong, nonatomic) NSMutableDictionary* smartContractPretendents;
@property (nonatomic, strong) NSMutableArray<Token*> *tokens;

@end

@implementation TokenManager

+ (instancetype)sharedInstance {
    
    static TokenManager *instance;
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
    }
    return self;
}

#pragma mark - Lazy Getters

-(NSMutableDictionary*)smartContractPretendents{
    
    if (!_smartContractPretendents) {
        _smartContractPretendents = @{}.mutableCopy;
    }
    return _smartContractPretendents;
}

- (NSMutableArray<Token*>*)tokens {
    if (!_tokens) {
        _tokens = @[].mutableCopy;
    }
    return _tokens;
}

#pragma mark - Keychain Methods

- (BOOL)save {
    
    BOOL isSavedTokens = [[FXKeychain defaultKeychain] setObject:self.tokens forKey:kTokenKeys];
    
    BOOL isSavedPretendents = [[FXKeychain defaultKeychain] setObject:[self.smartContractPretendents copy] forKey:kSmartContractPretendentsKey];
    return isSavedTokens && isSavedPretendents;
}

- (void)load {
    
    NSMutableArray *savedTokens = [[[FXKeychain defaultKeychain] objectForKey:kTokenKeys] mutableCopy];
    
    for (Token *token in savedTokens) {
        token.delegate = self;
        token.manager = self;
        [token loadToMemory];
    }
    self.smartContractPretendents = [[[FXKeychain defaultKeychain] objectForKey:kSmartContractPretendentsKey] mutableCopy];
    self.tokens = savedTokens;
}

#pragma mark - Public Methods

#pragma mark - Private Methods


- (NSArray <Token*>*)gatAllTokens{
    
    return self.tokens;
}

- (void)addNewToken:(Token*) token{
    
    token.delegate = self;
    [self.tokens addObject:token];
    [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:token withHandler:nil];
    [self tokenDidChange:token];
}

- (void)updateTokenWithAddress:(NSString*) address withNewBalance:(NSString*) balance{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",address];
    NSArray *filteredArray = [self.tokens filteredArrayUsingPredicate:predicate];
    Token* token = filteredArray[0];
    if (token) {
        token.balance = [balance floatValue];
        [self tokenDidChange:token];
    }
}

- (void)removeAllTokens{
    
    [self.tokens removeAllObjects];
}

- (void)removeAllPretendents{
    
    [self.smartContractPretendents removeAllObjects];
}

-(void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key{
    
    [self.smartContractPretendents setObject:addresses forKey:key];
    [self save];
}

-(void)deleteSmartContractPretendentWithKey:(NSString*) key{
    
    [self.smartContractPretendents removeObjectForKey:key];
}

-(void)updateSmartContractPretendent:(BTCTransaction*) transaction{
    //TODO update Token Transaction
}

-(void)checkSmartContract:(HistoryElement*) item {
    
    if (item.confirmed && item.isSmartContractCreater) {
        NSString* key = item.txHash;
        NSArray* tokenInfo = [self.smartContractPretendents objectForKey:key];
        
        if (tokenInfo) {
            Token* token = [Token new];
            [token setupWithHashTransaction:key andAddresses:tokenInfo];
            [self addNewToken:token];
            token.manager = self;
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self deleteSmartContractPretendentWithKey:key];
            [self save];
        }
    }
}

#pragma mark - TokenDelegate

- (void)tokenDidChange:(id)token {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidChange object:nil userInfo:nil];
    [self save];
}

#pragma mark - Managerable

-(void)updateSpendableObject:(id <Spendable>) object {
    
}

-(void)updateBalanceOfSpendableObject:(id <Spendable>) object withHandler:(void (^)(BOOL))complete {
    [complete copy];
    complete(NO);
    NSLog(@"complete ->%@",complete);
}

-(void)updateHistoryOfSpendableObject:(id <Spendable>) object withHandler:(void (^)(BOOL))complete andPage:(NSInteger) page{
    [complete copy];
    complete(NO);
    object.historyStorage.pageIndex = page;
    NSLog(@"complete ->%@",complete);
}

-(void)startObservingForSpendable{
    
    for (Token* token in self.tokens) {
        [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:token withHandler:nil];
    }
}

-(void)stopObservingForSpendable{
    //empty because wallet manager with stopin disconect from socket and this will also remove bserving from tokens too
}


-(void)loadSpendableObjects {
    [self load];
}

-(void)saveSpendableObjects {
    [self save];
}

-(void)updateSpendableWithObject:(id) updateObject{
    
}


-(void)updateSpendablesBalansesWithObject:(id) updateObject{
    
}

-(void)updateSpendablesHistoriesWithObject:(id) updateObject{
    
}

-(void)spendableDidChange:(id <Spendable>) object{
    [self tokenDidChange:object];
}

-(void)clear{
    
    [self removeAllTokens];
    [self removeAllPretendents];
    [self save];
}

@end
