//
//  KeysManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 31.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "KeysManager.h"
#import "FXKeychain.h"
#import "RPCRequestManager.h"

NSString const *kKeychainKey = @"qtum_wallet_private_keys";

@interface KeysManager ()

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *keysForTransaction;

@end

@implementation KeysManager

+ (instancetype)sharedInstance
{
    static KeysManager *instance;
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

#pragma mark - 

- (void)createNewKey
{
    BTCKey *newKey = [[BTCKey alloc] init];
    
    __weak typeof (self) weakSelf = self;
    [[RPCRequestManager sharedInstance] registerKey:newKey.uncompressedPublicKeyAddress.string new:YES withSuccessHandler:^(id responseObject) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:weakSelf.keys];
        [mutArray addObject:newKey];
        weakSelf.keys = [NSArray arrayWithArray:mutArray];
        weakSelf.keysForTransaction = [weakSelf.keys copy];
        [weakSelf save];
        
        if (weakSelf.keyRegistered)
            weakSelf.keyRegistered(YES);
    } andFailureHandler:^(NSError *error, NSString *message) {
        if (weakSelf.keyRegistered)
            weakSelf.keyRegistered(NO);
    }];
}

#pragma mark - KeyChain

- (BOOL)save
{
    NSArray *savingArray = [self p_createArrayForSaving];
    
    BOOL result = [[FXKeychain defaultKeychain] setObject:savingArray forKey:kKeychainKey];
    return result;
}

- (void)load
{
    NSArray *savedArrray = [[FXKeychain defaultKeychain] objectForKey:kKeychainKey];
    
    [self p_createArrayFromSavedValues:savedArrray];
}

- (BOOL)removeAllKeys
{
    self.keys = nil;
    self.keysForTransaction = nil;
    return [[FXKeychain defaultKeychain] removeObjectForKey:kKeychainKey];
}

- (NSArray *)p_createArrayForSaving
{
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSInteger i = 0; i < self.keys.count; i++) {
        BTCKey *key = self.keys[i];
        NSData *privateKeyData = [NSData dataWithData:key.privateKey];
        [mutArray addObject:privateKeyData];
    }
    
    return [NSArray arrayWithArray:mutArray];
}

- (void)p_createArrayFromSavedValues:(NSArray *)savedValues
{
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSInteger i = 0; i < savedValues.count; i++) {
        NSData *privateKeyData = savedValues[i];
        BTCKey *key = [[BTCKey alloc] initWithPrivateKey:privateKeyData];
        [mutArray addObject:key];
    }
    
    self.keys = [NSArray arrayWithArray:mutArray];
    self.keysForTransaction = [self.keys copy];
}

@end
