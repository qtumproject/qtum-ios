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
NSString const *kKeychainKeyLabel = @"qtum_wallet_label";

@interface KeysManager ()

@property (nonatomic, strong) NSString *label;
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

#pragma mark - 

- (void)createNewLabel
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    self.label = uuid;
}

#pragma mark - KeyChain

- (BOOL)save
{
    NSArray *savingArray = [self p_createArrayForSaving];
    
    BOOL resultKeys = [[FXKeychain defaultKeychain] setObject:savingArray forKey:kKeychainKey];
    BOOL resultLabel = [[FXKeychain defaultKeychain] setObject:self.label forKey:kKeychainKeyLabel];
    
    return resultKeys && resultLabel;
}

- (void)load
{
    NSArray *savedArrray = [[FXKeychain defaultKeychain] objectForKey:kKeychainKey];
    [self p_createArrayFromSavedValues:savedArrray];
    
    NSString *label = [[FXKeychain defaultKeychain] objectForKey:kKeychainKeyLabel];
    if (!label) {
        [self createNewLabel];
        [self save];
    }else{
        self.label = label;
    }
}

- (void)removeAllKeys
{
    self.keys = nil;
    self.keysForTransaction = nil;
    self.label = nil;
    [[FXKeychain defaultKeychain] removeObjectForKey:kKeychainKey];
    [[FXKeychain defaultKeychain] removeObjectForKey:kKeychainKeyLabel];
    return;
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
