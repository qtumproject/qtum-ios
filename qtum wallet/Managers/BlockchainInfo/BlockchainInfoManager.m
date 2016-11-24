//
//  BalanceManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BlockchainInfoManager.h"
#import "RPCRequestManager.h"
#import "KeysManager.h"
#import "HistoryElement.h"

@implementation BlockchainInfoManager

#pragma mark - Balance
+ (void)getBalanceForAddreses:(NSArray *)keyAddreses withSuccessHandler:(void(^)(double responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    [[RPCRequestManager sharedInstance] getListUnspentForKeys:keyAddreses withSuccessHandler:^(id responseObject) {
        success([BlockchainInfoManager calculateBalance:responseObject]);
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
    [[RPCRequestManager sharedInstance] getListUnspentForKeys:keyAddreses withSuccessHandler:^(id responseObject) {
        success([BlockchainInfoManager createArray:responseObject]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (NSArray *)createArray:(NSArray *)responseObject
{
    NSMutableArray* outputs = [NSMutableArray array];
    
    for (NSDictionary* item in responseObject) {
        BTCTransactionOutput* txout = [[BTCTransactionOutput alloc] init];
        
        txout.value = [self convertValueToAmount:[item[@"amount"] doubleValue]];
        txout.script = [[BTCScript alloc] initWithData:BTCDataFromHex(item[@"scriptPubKey"])];
        txout.index = [item[@"vout"] intValue];
        txout.confirmations = [item[@"confirmations"] unsignedIntegerValue];
        txout.transactionHash = (BTCDataFromHex([self invertHex:item[@"txid"]]));
        
        [outputs addObject:txout];
        
        // Dictionary for outputs and address
//        NSDictionary *dictionary = @{@"tout" : txout, @"address" : item[@"address"]};
//        [outputs addObject:dictionary];
    }
    
    return outputs;
}

+ (NSString *)invertHex:(NSString *)hexString
{
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

+ (void)getHistoryForAddresses:(NSArray *)keyAddreses withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    __weak typeof(self) weakSelf = self;
    [[RPCRequestManager sharedInstance] getHistory:^(id responseObject) {
        NSLog(@"%@", responseObject);
        success([weakSelf createHistoryElements:responseObject]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        NSLog(@"%@", error);
        failure(error, message);
    }];
}

+ (void)getHistoryForAllAddresesWithSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    NSArray *allKeys = [self createAllKeysArray];
    
    [self getHistoryForAddresses:allKeys withSuccessHandler:^(NSArray *responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

+ (NSArray *)createHistoryElements:(NSArray *)responseObject
{
    responseObject = [[responseObject reverseObjectEnumerator] allObjects];
    
    NSMutableArray *array = [NSMutableArray new];
    for (NSDictionary *dictionary in responseObject) {
        HistoryElement *element = [HistoryElement new];
        
        element.amount = dictionary[@"amount"];
        element.address = dictionary[@"address"];
        element.dateNumber = dictionary[@"time"];
        element.send = ![self checkIsMineAddress:element.address];
        
        [array addObject:element];
    }
    
    return  array;
}

+ (BOOL)checkIsMineAddress:(NSString *)address
{
    NSArray *mineAddresses = [self createAllKeysArray];
    
    for (NSString *mineAddress in mineAddresses) {
        if ([address isEqualToString:mineAddress]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Methods

+ (BTCAmount)convertValueToAmount:(double)value
{
    return value * BTCCoin;
}

+ (NSArray *)createAllKeysArray
{
    NSMutableArray *array = [NSMutableArray new];
    for (BTCKey *key in [KeysManager sharedInstance].keys) {
        [array addObject:key.address.string];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
