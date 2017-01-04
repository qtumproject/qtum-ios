//
//  Wallet.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 15.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "Wallet.h"

NSInteger const WORDS_COUNT = 12;
NSInteger const USERS_KEYS_COUNT = 100;

@interface Wallet () <NSCoding>

@property (nonatomic) NSInteger countOfUsedKeys;
@property (nonatomic) NSArray *seedWords;
@property (nonatomic) BTCKey *lastRandomKey;

@property (nonatomic) BTCKeychain *keyChain;

@end

@implementation Wallet

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin
{
    self = [super init];
    if (self) {
        self.name = name;
        self.pin = pin;
        self.countOfUsedKeys = USERS_KEYS_COUNT;
        self.seedWords = [self generateWordsArray];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords
{
    self = [super init];
    if (self) {
        self.name = name;
        self.pin = pin;
        self.countOfUsedKeys = USERS_KEYS_COUNT;
        self.seedWords = seedWords;
        
        if (!self.keyChain) {
            return nil;
        }
    }
    return self;
}

#pragma mamrk - Setters

- (void)setSeedWords:(NSArray *)seedWords
{
    _seedWords = seedWords;
    if (!self.keyChain) {
        self.keyChain = [self createKeychain];
    }
}

- (void)setName:(NSString *)name
{
    _name = name;
    [self walletDidChange];
}

- (void)setPin:(NSString *)pin
{
    _pin = pin;
    [self walletDidChange];
}

#pragma mark - Public Methods

- (BTCKey *)getRandomKey
{
    uint randomedIndex = arc4random() % self.countOfUsedKeys;
    
    BTCKey *newKey = [self.keyChain keyAtIndex:randomedIndex];
    self.lastRandomKey = newKey;
    return newKey;
}

-(BTCKey*)getLastRandomKeyOrRandomKey{
    if (!self.lastRandomKey) {
        return [self getRandomKey];
    }else {
        return self.lastRandomKey;
    }
}

- (BTCKey *)getKeyAtIndex:(NSUInteger)index;
{
    return [self.keyChain keyAtIndex:(uint)index];
}

- (NSArray *)getAllKeys
{
    NSMutableArray *allKeys = [NSMutableArray new];
    for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
        [allKeys addObject:[self.keyChain keyAtIndex:(uint)i]];
    }
    return allKeys;
}

- (NSString *)getWorldsString
{
    return [self.seedWords componentsJoinedByString:@" "];
}

#pragma mark - Private Methods

- (BTCKeychain *)createKeychain
{
    BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:self.seedWords password:nil wordListType:BTCMnemonicWordListTypeUnknown];
    BTCKeychain *keyChain = [[BTCKeychain alloc] initWithSeed:mnemonic.seed];
    return keyChain;
}

- (NSArray *)generateWordsArray
{
    NSMutableArray *randomWords = [NSMutableArray new];
    
    NSInteger i = 0;
    
    while (i < WORDS_COUNT) {
        uint32_t rnd = arc4random_uniform((uint32_t)wordsArray().count);
        NSString *randomWord = [wordsArray() objectAtIndex:rnd];
        
        if (![randomWords containsObject:randomWord]) {
            [randomWords addObject:randomWord];
            i++;
        }
    }
    
    return randomWords;
}

- (void)walletDidChange
{
    if ([self.delegate respondsToSelector:@selector(walletDidChange:)]) {
        [self.delegate walletDidChange:self];
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"Name"];
    [aCoder encodeObject:self.pin forKey:@"Pin"];
    [aCoder encodeObject:self.seedWords forKey:@"Seed"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *name = [aDecoder decodeObjectForKey:@"Name"];
    NSString *pin = [aDecoder decodeObjectForKey:@"Pin"];
    NSArray *seedWords = [aDecoder decodeObjectForKey:@"Seed"];
    
    self = [super init];
    if (self) {
        self.name = name;
        self.pin = pin;
        self.countOfUsedKeys = USERS_KEYS_COUNT;
        self.seedWords = seedWords;
    }
    
    return self;
}

@end
