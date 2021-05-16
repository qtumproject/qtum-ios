//
//  Wallet.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 15.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSUserDefaults+Settings.h"
#import "NSString+AES256.h"

NSInteger const brandKeyWordsCount = 12;
NSInteger const USERS_KEYS_COUNT = 10;

@interface Wallet () <NSCoding>

@property (assign, nonatomic) NSInteger countOfUsedKeys;
@property (copy, nonatomic) NSString *encriptedBrandKey;
@property (strong, nonatomic) NSString *lastRandomKey;
@property (strong, nonatomic) BTCKeychain *keyChain;
@property (strong, nonatomic) NSArray <NSString*>* addresses;

@end

@implementation Wallet

@synthesize symbol = _symbol;
@synthesize balance = _balance;
@synthesize unconfirmedBalance = _unconfirmedBalance;
@synthesize historyStorage = _historyStorage;
@synthesize name = _name;
@synthesize historyArray = _historyArray;
@synthesize manager = _manager;
@synthesize mainAddress = _mainAddress;


- (instancetype)initWithName:(NSString *) name pin:(NSString *) pin {

	self = [super init];
	if (self) {
		_name = name;
		_balance = [QTUMBigNumber decimalWithInteger:0];
		_unconfirmedBalance = [QTUMBigNumber decimalWithInteger:0];
		_countOfUsedKeys = USERS_KEYS_COUNT;
        _encriptedBrandKey = [NSString encryptString:[self stringFromWorldsArray:[[self class] generateWordsArray]] withKey:pin];
		[_manager spendableDidChange:self];
	}
	return self;
}

- (instancetype)initWithName:(NSString *) name pin:(NSString *) pin seedWords:(NSArray *) seedWords {

	self = [super init];
	if (self) {
		_name = name;
		_balance = [QTUMBigNumber decimalWithInteger:0];
		_unconfirmedBalance = [QTUMBigNumber decimalWithInteger:0];
		_countOfUsedKeys = USERS_KEYS_COUNT;
		_encriptedBrandKey = [NSString encryptString:[self stringFromWorldsArray:seedWords] withKey:pin];
		[_manager spendableDidChange:self];
	}
	return self;
}

- (NSString *)brandKeyWithPin:(NSString *) pin {

	return [NSString decryptString:self.encriptedBrandKey withKey:pin];
}


- (BOOL)configAddressesWithPin:(NSString *) pin {

	NSString *stringBrandKey = [self brandKeyWithPin:pin];

	if (stringBrandKey) {

		NSArray *seedWords = [stringBrandKey componentsSeparatedByString:@" "];
		self.keyChain = [self createKeychainWithSeedWords:seedWords];

		if (self.keyChain) {
			[self savePublicAddresses];
		}
	} else {
		self.keyChain = nil;
		[self savePublicAddresses];
	}

    return self.keyChain ? YES : NO;
}

- (void)savePublicAddresses {

	NSMutableArray *addresses = [NSMutableArray new];
	for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
		BTCKey *key = [self.keyChain keyAtIndex:(uint)i hardened:YES];
		NSString *keyString = SLocator.appSettings.isMainNet ? key.address.string : key.addressTestnet.string;
		if (keyString) {
			[addresses addObject:keyString];
		}
	}
    self.addresses = addresses;
	[NSUserDefaults savePublicAddresses:addresses];
}

- (void)clearPublicAddresses {

    self.addresses = nil;
	[NSUserDefaults savePublicAddresses:nil];
	[SLocator.dataOperation deleteGroupFileWithName:groupFileName valueForKey:@"kWalletAddressKey"];
}

- (BOOL)changeBrandKeyPinWithOldPin:(NSString *) pin toNewPin:(NSString *) newPin {

	NSString *stringBrandKey = [self brandKeyWithPin:pin];
	if (stringBrandKey) {
		NSString *newEncriptedBrandKey = [NSString encryptString:stringBrandKey withKey:newPin];
		if (newEncriptedBrandKey) {
			self.encriptedBrandKey = [NSString encryptString:stringBrandKey withKey:newPin];
		}
        return newEncriptedBrandKey ? YES : NO;
	}
	return NO;
}


#pragma mamrk - Setters

- (void)setName:(NSString *) name {

	_name = name;
	[self.manager spendableDidChange:self];
}


- (NSArray <HistoryElementProtocol> *)historyArray {

	return [self.historyStorage.historyPrivate copy];
}

- (NSString *)mainAddress {

	if (!_mainAddress) {

		NSString *mainAddress = [self getStoredLastAddressKey];
		if (!mainAddress || ![self.addresses containsObject:mainAddress]) {
			NSString *key = [self lastRandomKeyOrRandomKey];
            mainAddress = key;
		}
		_mainAddress = mainAddress;
	}

	return _mainAddress;
}

-(QTUMBigNumber *)balance {
    return _balance;
}

-(QTUMBigNumber *)unconfirmedBalance {
    return _unconfirmedBalance;
}

- (void)changeMainAddress:(NSString *) mainAddress {

	self.mainAddress = mainAddress;
	[SLocator.dataOperation addGropFileWithName:groupFileName dataSource:@{@"kWalletAddressKey": mainAddress}];
}

- (NSString *)symbol {

	return NSLocalizedString(@"HTML", @"HTML sybmol");
}

#pragma mark - Public Methods

- (NSString *)randomKey {

	uint randomedIndex = arc4random () % self.countOfUsedKeys;
    NSString *newKey = self.addresses[randomedIndex];
	[self storeLastAdrees:newKey];
	self.lastRandomKey = newKey;
	return newKey;
}

- (NSString *)lastRandomKeyOrRandomKey {

	if (!self.lastRandomKey) {

		NSString *key = [self randomKey];
		[self storeLastAdrees:key];
		return key;
	} else {
		return self.lastRandomKey;
	}
}

- (void)storeLastAdrees:(NSString *) keyString {

	if (!keyString) {
		return;
	}
	[SLocator.dataOperation addGropFileWithName:groupFileName dataSource:@{@"kWalletAddressKey": keyString}];
}

- (NSString *)getStoredLastAddressKey {
	return [[SLocator.dataOperation getDictFormGroupFileWithName:groupFileName] objectForKey:@"kWalletAddressKey"];
}

- (BTCKey *)keyAtIndex:(NSUInteger) index {

	return [self.keyChain keyAtIndex:(uint)index hardened:YES];
}

- (NSArray *)allKeys {

	NSMutableArray *allKeys = [NSMutableArray new];
	for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
		if ([self.keyChain keyAtIndex:(uint)i hardened:YES]) {
			[allKeys addObject:[self.keyChain keyAtIndex:(uint)i hardened:YES]];
		}
	}
	return [allKeys copy];
}

- (NSString *)stringFromWorldsArray:(NSArray *) words {

	return [words componentsJoinedByString:@" "];
}

- (NSArray <NSString *> *)allKeysAdreeses {

	return [NSUserDefaults getPublicAddresses];
}

- (NSDictionary <NSString *, BTCKey *> *)addressKeyHashTable {

	if (!self.keyChain) {
		return nil;
	}

	NSMutableDictionary *addressKeyHashTable = @{}.mutableCopy;

	for (NSInteger i = 0; i < self.countOfUsedKeys; i++) {
		BTCKey *key = [self.keyChain keyAtIndex:(uint)i hardened:YES];
		NSString *keyString = SLocator.appSettings.isMainNet ? key.address.string : key.addressTestnet.string;
		[addressKeyHashTable setObject:key forKey:keyString];
	}
	return [addressKeyHashTable copy];
}

- (NSArray *)addressesInRightOrder {

	if (!self.addresses) {
		return nil;
	}
    
	return [self.addresses copy];
}

#pragma mark - Private Methods

- (BTCKeychain *)createKeychainWithSeedWords:(NSArray *) seedWords {

	BTCMnemonic *mnemonic = [[BTCMnemonic alloc] initWithWords:seedWords password:nil wordListType:BTCMnemonicWordListTypeUnknown];
	BTCKeychain *keyChain = [mnemonic.keychain derivedKeychainWithPath:@"m/88'/0'"];

	return keyChain;
}

+ (NSArray *)generateWordsArray {

	NSMutableArray *randomWords = [NSMutableArray new];

	NSInteger i = 0;

	while (i < brandKeyWordsCount) {
		uint32_t rnd = arc4random_uniform ((uint32_t)wordsArray ().count);
		NSString *randomWord = wordsArray ()[rnd];

		if (![randomWords containsObject:randomWord]) {
			[randomWords addObject:randomWord];
			i++;
		}
	}

	return randomWords;
}

- (void)clearKeychain {
    [self.keyChain clear];
    self.keyChain = nil;
}



#pragma mark - Spendable

- (void)updateBalanceWithHandler:(void (^)(BOOL)) complete {
	[self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

- (void)updateHistoryWithHandler:(void (^)(BOOL)) complete andPage:(NSInteger) page {
	[self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

- (void)updateWithHandler:(void (^)(BOOL success)) complete {
	complete (NO);
}

- (void)historyDidChange {

	[self.manager historyOfSpendableDidChange:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *) aCoder {

	[aCoder encodeObject:self.name forKey:@"Name"];
	[aCoder encodeObject:self.encriptedBrandKey forKey:@"encriptedBrandKey"];
}

- (nullable instancetype)initWithCoder:(NSCoder *) aDecoder {

	NSString *name = [aDecoder decodeObjectForKey:@"Name"];
	NSString *encriptedBrandKey = [aDecoder decodeObjectForKey:@"encriptedBrandKey"];

	self = [super init];
	if (self) {
		_name = name;
		_countOfUsedKeys = USERS_KEYS_COUNT;
		_balance = [QTUMBigNumber decimalWithInteger:0];
		_unconfirmedBalance = [QTUMBigNumber decimalWithInteger:0];
		_encriptedBrandKey = encriptedBrandKey;
		[_manager spendableDidChange:nil];
	}

	return self;
}

@end
