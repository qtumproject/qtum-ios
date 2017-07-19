//
//  Wallet.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 15.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "Wallet.h"
#import "HistoryDataStorage.h"
#import "NSUserDefaults+Settings.h"
#import "NSString+AES256.h"

NSInteger const brandKeyWordsCount = 12;
NSInteger const USERS_KEYS_COUNT = 10;

@interface Wallet () <NSCoding>

@property (assign, nonatomic) NSInteger countOfUsedKeys;
@property (copy, nonatomic) NSString* encriptedBrandKey;
@property (strong, nonatomic) BTCKey *lastRandomKey;
@property (strong, nonatomic) BTCKeychain *keyChain;
@property (copy, nonatomic) NSArray* seedWords;

@end

@implementation Wallet

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin {
    
    self = [super init];
    if (self) {
        _name = name;
        _countOfUsedKeys = USERS_KEYS_COUNT;
        _encriptedBrandKey = [NSString encryptString:[self stringFromWorldsArray:[self generateWordsArray]] withKey:pin];
        [_manager spendableDidChange:self];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords {
    
    self = [super init];
    if (self) {
        _name = name;
        _countOfUsedKeys = USERS_KEYS_COUNT;
        _encriptedBrandKey = [NSString encryptString:[self stringFromWorldsArray:seedWords] withKey:pin];
        [_manager spendableDidChange:self];
    }
    return self;
}

- (NSString *)brandKeyWithPin:(NSString*) pin {
    
    return [NSString decryptString:self.encriptedBrandKey withKey:pin];
}


-(BOOL)configAddressesWithPin:(NSString*) pin {
    
    NSString* stringBrandKey = [self brandKeyWithPin:pin];
    
    if (stringBrandKey) {
        NSArray* seedWords = [stringBrandKey componentsSeparatedByString:@" "];
        self.keyChain = [self createKeychainWithSeedWords:seedWords];
    } else {
        DLog(@"Cant Create seed words from Pin");
    }
    
    return self.keyChain;
}

#pragma mamrk - Setters

- (void)setName:(NSString *)name {
    
    _name = name;
    [self.manager spendableDidChange:self];
}


-(NSArray <HistoryElementProtocol>*)historyArray{
    return [self.historyStorage.historyPrivate copy];
}

-(NSString *)mainAddress {
    
    BTCKey* key = [self lastRandomKeyOrRandomKey];
    NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
    return keyString;
}

-(NSString *)symbol{

    return  NSLocalizedString(@"QTUM", @"QTUM sybmol");
}


#pragma mark - Public Methods

- (BTCKey *)randomKey {
    
    uint randomedIndex = arc4random() % self.countOfUsedKeys;
    BTCKey *newKey = [self.keyChain keyAtIndex:randomedIndex hardened:YES];
    [self storeLastAdreesKey:newKey];
    self.lastRandomKey = newKey;
    return newKey;
}

-(BTCKey*)lastRandomKeyOrRandomKey {
    
    if (!self.lastRandomKey) {
        
        BTCKey* key = [self randomKey];
        [self storeLastAdreesKey:key];
        return key;
    }else {
        return self.lastRandomKey;
    }
}

-(void)storeLastAdreesKey:(BTCKey*) btcKey{
    NSString* keyString = [AppSettings sharedInstance].isMainNet ? btcKey.address.string : btcKey.addressTestnet.string;
    [NSUserDefaults saveWalletAddressKey:keyString];
}

- (BTCKey *)keyAtIndex:(NSUInteger)index;
{
    return [self.keyChain keyAtIndex:(uint)index hardened:YES];
}

- (NSArray *)allKeys {
    
    NSMutableArray *allKeys = [NSMutableArray new];
    for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
        [allKeys addObject:[self.keyChain keyAtIndex:(uint)i hardened:YES]];
    }
    return allKeys;
}

- (NSString *)stringFromWorldsArray:(NSArray*) words {
    
    return [words componentsJoinedByString:@" "];
}

- (NSArray <NSString*>*)allKeysAdreeses {
    
    NSMutableArray *allKeysString = [NSMutableArray new];
    for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
        BTCKey* key = [self.keyChain keyAtIndex:(uint)i hardened:YES];
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? key.address.string : key.addressTestnet.string;
        [allKeysString addObject:keyString];
    }
    return allKeysString;
}

#pragma mark - Private Methods

- (BTCKeychain *)createKeychainWithSeedWords:(NSArray*) seedWords {
    
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:seedWords password:nil wordListType:BTCMnemonicWordListTypeUnknown];
    BTCKeychain *keyChain = [mnemonic.keychain derivedKeychainWithPath:@"m/0'/0'"];

    return keyChain;
}

- (NSArray *)generateWordsArray
{
    NSMutableArray *randomWords = [NSMutableArray new];
    
    NSInteger i = 0;
    
    while (i < brandKeyWordsCount) {
        uint32_t rnd = arc4random_uniform((uint32_t)wordsArray().count);
        NSString *randomWord = wordsArray()[rnd];
        
        if (![randomWords containsObject:randomWord]) {
            [randomWords addObject:randomWord];
            i++;
        }
    }
    
    return randomWords;
}


#pragma mark - Spendable

-(void)updateBalanceWithHandler:(void (^)(BOOL))complete{
    [self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

-(void)updateHistoryWithHandler:(void (^)(BOOL))complete andPage:(NSInteger) page{
    [self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

-(void)loadToMemory {
    
    _historyStorage = [HistoryDataStorage new];
    _historyStorage.spendableOwner = self;
}

-(void)updateHandler:(void(^)(BOOL success)) complete {
    complete(NO);
}

-(void)historyDidChange{
    [self.manager spendableDidChange:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.encriptedBrandKey forKey:@"encriptedBrandKey"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"Name"];
    NSString *encriptedBrandKey = [aDecoder decodeObjectForKey:@"encriptedBrandKey"];
    NSArray *seedWords = [aDecoder decodeObjectForKey:@"Seed"];
    
    self = [super init];
    if (self) {
        _name = name;
        _seedWords = seedWords;
        _countOfUsedKeys = USERS_KEYS_COUNT;
        _encriptedBrandKey = encriptedBrandKey;
        [_manager spendableDidChange:nil];
    }
    
    return self;
}

@end
