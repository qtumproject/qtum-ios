//
//  TokenManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 12.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenManager.h"
#import "HistoryElement.h"
#import "FXKeychain.h"
#import "Token.h"

NSString const *kTokenKeys = @"qtum_token_tokens_keys";
NSString *const kTokenUpdateEvent = @"TokenUpdateEvent";

static NSString* kSmartContractPretendentsKey = @"smartContractPretendentsKey";

@interface TokenManager () <TokenDelegate>

@property (strong, nonatomic) NSMutableDictionary* smartContractPretendents;
@property (nonatomic, strong) NSMutableArray<Token*> *tokens;

@end

@implementation TokenManager

+ (instancetype)sharedInstance
{
    static TokenManager *instance;
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

- (NSArray <Token*>*)gatAllTokens{
    
    return self.tokens;
}

- (BOOL)save {
    
    BOOL isSavedTokens = [[FXKeychain defaultKeychain] setObject:self.tokens forKey:kTokenKeys];
    if ([[FXKeychain defaultKeychain] objectForKey:kSmartContractPretendentsKey]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:kSmartContractPretendentsKey];
    }
    [[FXKeychain defaultKeychain] setObject:[self.smartContractPretendents copy] forKey:kSmartContractPretendentsKey];
    return isSavedTokens;
}

- (void)load {
    
    NSMutableArray *savedTokens = [[[FXKeychain defaultKeychain] objectForKey:kTokenKeys] mutableCopy];

    for (Token *token in savedTokens) {
        token.delegate = self;
    }
    self.smartContractPretendents = [[[FXKeychain defaultKeychain] objectForKey:kSmartContractPretendentsKey] mutableCopy];
    self.tokens = savedTokens;
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
        token.balance = balance;
        [self tokenDidChange:token];
    }
}

- (void)removeAllTokens{
    
    [self.tokens removeAllObjects];
}

-(void)saveInKeychain{

}

-(void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key{
    [self.smartContractPretendents setObject:addresses forKey:key];
    [self saveInKeychain];
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
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self deleteSmartContractPretendentWithKey:key];
            [self saveInKeychain];
        }
    }
}

#pragma mark - TokenDelegate

- (void)tokenDidChange:(id)token {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenUpdateEvent object:nil userInfo:nil];
    [self save];
}


#pragma mark - Managerable

-(void)updateSpendableObject:(id <Spendable>) object {
    
}

-(void)updateBalanceOfSpendableObject:(id <Spendable>) object {
    
}

-(void)updateHistoryOfSpendableObject:(id <Spendable>) object {
    
}

-(void)startObservingForSpendable{
    for (Token* token in self.tokens) {
        [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:token withHandler:nil];
    }
}

-(void)stopObservingForSpendable{
    
}

-(void)loadSpendableObjects {
    [self load];
}

-(void)saveSpendableObjects {
    [self save];
}

@end
