//
//  BalanceManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BlockchainInfoManager.h"
#import "RPCRequestManager.h"
#import "HistoryElement.h"
#import "HistoryAndBalanceDataStorage.h"
#import "BTCTransactionInput+Extension.h"
#import "BTCTransactionOutput+Address.h"
#import "TokenManager.h"

@implementation BlockchainInfoManager

#pragma mark - Balance
+ (void)getBalanceForAddreses:(NSArray *)keyAddreses withSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    [[WalletManager sharedInstance].requestManager getUnspentOutputsForAdreses:keyAddreses isAdaptive:YES successHandler:^(id responseObject) {
        success([[self class] calculateBalance:responseObject]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (void)getBalanceForAllAddresesWithSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    NSArray *allKeys = [self createAllKeysArray];
    
    [self getBalanceForAddreses:allKeys withSuccessHandler:^(double responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (double)calculateBalance:(NSArray *)responseObject
{
    double balance = 0;
    
    for (NSDictionary *dictionary in responseObject) {
        double amount = [dictionary[@"amount"] doubleValue];
        balance += amount;
    }
    
    return balance;
}

#pragma mark - Outputs

+ (void)getunspentOutputs:(NSArray *)keyAddreses withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    [[WalletManager sharedInstance].requestManager getUnspentOutputsForAdreses:keyAddreses isAdaptive:YES successHandler:^(id responseObject) {
        success([[self class] createArray:responseObject]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (NSArray *)createArray:(NSArray *)responseObject{
    
    NSMutableArray* outputs = [NSMutableArray array];
    
    for (NSDictionary* item in responseObject) {
        BTCTransactionOutput* txout = [[BTCTransactionOutput alloc] init];
        
        txout.value = [self convertValueToAmount:[item[@"amount"] doubleValue]];
        txout.script = [[BTCScript alloc] initWithData:BTCDataFromHex(item[@"txout_scriptPubKey"])];
        txout.index = [item[@"vout"] intValue];
        txout.confirmations = [item[@"confirmations"] unsignedIntegerValue];
        txout.transactionHash = (BTCDataFromHex([self invertHex:item[@"tx_hash"]]));
        txout.blockHeight = [item[@"confirmations"] integerValue];
        txout.runTimeAddress = item[@"address"];
        
        [outputs addObject:txout];
    }
    
    return outputs;
}

+ (NSString *)invertHex:(NSString *)hexString{
    
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [hexString length];
    
    while (hexString && charIndex > 0) {
        charIndex -= 2;
        NSRange subStrRange = NSMakeRange(charIndex, 2);
        NSString *substring = [hexString substringWithRange:subStrRange];
        [reversedString appendString:[substring substringWithRange:NSMakeRange(0, 1)]];
        [reversedString appendString:[substring substringWithRange:NSMakeRange(1, 1)]];
    }
    
    return reversedString;
}

#pragma mark - History

+ (void)getHistoryForAddresses:(NSArray *)keyAddreses andParam:(NSDictionary*) param withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    __weak typeof(self) weakSelf = self;
    [[WalletManager sharedInstance].requestManager getHistoryWithParam:param andAddresses:keyAddreses successHandler:^(id responseObject) {
        NSArray* history = [weakSelf createHistoryElements:responseObject];
        success(history);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (void)getHistoryForAllAddresesWithSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure andParam:(NSDictionary*) param
{
    NSArray *allKeys = [self createAllKeysArray];
    
    [self getHistoryForAddresses:allKeys andParam:param withSuccessHandler:^(NSArray *responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (NSArray *)createHistoryElements:(NSArray *)responseObject{
    
    NSArray* responseObjectLocal = [[responseObject reverseObjectEnumerator] allObjects];
    NSMutableArray *array = [NSMutableArray new];
    
    for (NSDictionary *dictionary in responseObjectLocal) {
        HistoryElement *element = [[self class] createHistoryElement:dictionary];
        [array addObject:element];
    }
    
    return  array;
}


+ (HistoryElement *)createHistoryElement:(NSDictionary *)dictionary{
    
    HistoryElement *element = [HistoryElement new];
    [element setupWithObject:dictionary];
    [[TokenManager sharedInstance] checkSmartContract:element];
    return  element;
}

+(void)updateHistoryWithArray:(NSArray <HistoryElement*>*) array{
    [[HistoryAndBalanceDataStorage sharedInstance] setHistory:array];
}

+(void)updateHistoryWithItem:(HistoryElement*) item{
    [[HistoryAndBalanceDataStorage sharedInstance] setHistoryItem:item];
}

+(void)addHistoryElementWithDict:(NSDictionary*) dict {
    HistoryElement* item = [[self class] createHistoryElement:dict];
    [[self class] updateHistoryWithItem:item];
}

+ (void)updateBalance:(CGFloat) balance{
    [HistoryAndBalanceDataStorage sharedInstance].balance = balance;
}

#pragma mark - Methods

+ (BTCAmount)convertValueToAmount:(double)value
{
    return value * BTCCoin;
}

+ (NSArray *)createAllKeysArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (BTCKey *key in [[WalletManager sharedInstance].getCurrentWallet getAllKeys]) {
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        if (keyString) {
            [array addObject:keyString];
        }
    }
    
    return [NSArray arrayWithArray:array];
}

+ (NSDictionary *)getHashTableOfKeys{
    NSMutableDictionary *hashTable = [NSMutableDictionary new];
    for (BTCKey *key in [[WalletManager sharedInstance].getCurrentWallet getAllKeys]) {
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        if (keyString) {
            [hashTable setObject:[NSNull null] forKey:keyString];
        }
    }
    return [hashTable copy];
}

@end
