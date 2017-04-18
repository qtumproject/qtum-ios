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

static NSString* smartContractPretendentsKey = @"smartContractPretendentsKey";

@interface TokenManager ()

@property (strong, nonatomic) NSMutableDictionary* smartContractPretendents;
@property (strong, nonatomic) NSMutableDictionary* tokens;

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
        [self loadFromKeychain];
    }
    return self;
}

-(NSMutableDictionary*)smartContractPretendents{
    
    if (!_smartContractPretendents) {
        _smartContractPretendents = @{}.mutableCopy;
    }
    return _smartContractPretendents;
}

-(NSMutableDictionary*)tokens{
    
    if (!_tokens) {
        _tokens = @{}.mutableCopy;
    }
    return _tokens;
}

-(void)loadFromKeychain{
    self.smartContractPretendents = [[[FXKeychain defaultKeychain] objectForKey:smartContractPretendentsKey] mutableCopy];
}

-(void)saveInKeychain{
    if ([[FXKeychain defaultKeychain] objectForKey:smartContractPretendentsKey]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:smartContractPretendentsKey];
    }
    [[FXKeychain defaultKeychain] setObject:[self.smartContractPretendents copy] forKey:smartContractPretendentsKey];
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
            [[WalletManager sharedInstance] addNewToken:token];
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self deleteSmartContractPretendentWithKey:key];
            [self saveInKeychain];
        }
    }
}

@end
