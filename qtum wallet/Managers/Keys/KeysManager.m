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
NSString const *kUserPIN = @"PIN";


@interface KeysManager ()

//label for register keys as 1 wallet, need for RPC
@property (nonatomic, strong) NSString *label;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSArray *keysForTransaction;
@property (nonatomic, strong) NSString* PIN;

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
        ///if you want to remove all keys - uncomment removeAllKeys
        //[self removeAllKeys];
        [self load];
    }
    return self;
}

#pragma mark - Setter/Getter

-(NSString*)label{
    //bail if we remove label at logout
    if (!_label) {
        [self createNewLabel];
        [self save];
    }
    return _label;
}


#pragma mark - 

- (void)createNewKey
{
    BTCKey *newKey = [[BTCKey alloc] init];
    
    [self reggisterKey:newKey new:YES];
}

- (void)importKey:(NSString *)privateAddressString
{
    BTCKey *importKey = [[BTCKey alloc] initWithWIF:privateAddressString];
    
    for (BTCKey *addedKey in self.keys) {
        if ([importKey.WIF isEqualToString:addedKey.WIF]) {
            if (self.keyRegistered)
                self.keyRegistered(NO);
            return;
        }
    }
    
    [self reggisterKey:importKey new:NO];
}

- (void)reggisterKey:(BTCKey *)key new:(BOOL)new
{
    __weak typeof (self) weakSelf = self;
    [[RPCRequestManager sharedInstance] registerKey:key.address.string new:new withSuccessHandler:^(id responseObject) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:weakSelf.keys];
        [mutArray addObject:key];
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
    _label = uuid;
}

#pragma mark - KeyChain

- (BOOL)save
{
    NSArray *savingArray = [self p_createArrayForSaving];
    
    BOOL resultKeys = [[FXKeychain defaultKeychain] setObject:savingArray forKey:kKeychainKey];
    BOOL resultLabel = [[FXKeychain defaultKeychain] setObject:_label forKey:kKeychainKeyLabel];
    
    return resultKeys && resultLabel;
}

-(void)storePin:(NSString*) pin {
    if ([[FXKeychain defaultKeychain] objectForKey:kUserPIN]) {
        [[FXKeychain defaultKeychain] removeObjectForKey:kUserPIN];
    }
    [[FXKeychain defaultKeychain] setObject:pin forKey:kUserPIN];
    self.PIN = pin;
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
    self.PIN = [[FXKeychain defaultKeychain] objectForKey:kUserPIN];
}

- (void)removeAllKeys
{
    self.keys = nil;
    self.keysForTransaction = nil;
    self.label = nil;
    self.PIN = nil;
    [[FXKeychain defaultKeychain] removeObjectForKey:kKeychainKey];
    [[FXKeychain defaultKeychain] removeObjectForKey:kKeychainKeyLabel];
    [[FXKeychain defaultKeychain] removeObjectForKey:kUserPIN];
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
