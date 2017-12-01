//
//  TokenModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSDate+Extension.h"

@interface Contract ()

@property (strong, nonatomic) NSString *balanceString;
@property (strong, nonatomic) NSString *shortBalanceString;
@property (strong, nonatomic) NSString *totalSupplyString;
@property (strong, nonatomic) NSString *shortTotalSupplyString;

@end

@implementation Contract

- (instancetype)init {

	self = [super init];
	if (self) {

		_unconfirmedBalance = [[QTUMBigNumber alloc] initWithString:@"0"];
	}
	return self;
}

#pragma mark - Custom Accessors

- (void)setAddressBalanceDictionary:(NSDictionary<NSString *, QTUMBigNumber *> *) addressBalanceDictionary {

	self.balance = nil;
	self.balanceString = nil;
	self.shortBalanceString = nil;
	_addressBalanceDictionary = addressBalanceDictionary;
}

- (NSString *)creationDateString {

	return self.creationDate ? [self.creationDate formatedDateString] : nil;
}

- (NSString *)creationFormattedDateString {

	return self.creationDate ? [self.creationDate string] : nil;
}

- (NSString *)mainAddress {

	return self.contractAddress;
}

- (NSString *)totalSupplyString {

	if (!self.totalSupply || !self.decimals) {
		return @"";
	}

	if (!_totalSupplyString) {
		_totalSupplyString = [self.totalSupply stringNumberWithPowerOfMinus10:self.decimals];
	}
	return _totalSupplyString;
}

- (NSString *)shortTotalSupplyString {

	if (!self.totalSupply || !self.decimals) {
		return @"";
	}

	if (!_shortTotalSupplyString) {
		_shortTotalSupplyString = [self.totalSupply shortFormatOfNumberWithPowerOfMinus10:self.decimals];
	}
	return _shortTotalSupplyString;
}

- (QTUMBigNumber *)balance {

	if (!_balance) {
		NSArray *values = self.addressBalanceDictionary.allValues;
		QTUMBigNumber *balanceDecimal = [[QTUMBigNumber alloc] initWithString:@"0"];

		for (QTUMBigNumber *balanceValue in values) {

			balanceDecimal = [balanceDecimal add:balanceValue];
		}
		_balance = balanceDecimal;
	}

	return _balance;
}

- (NSString *)balanceString {

	if (!self.balance || !self.decimals) {
		return @"";
	}

	if (!_balanceString) {
		_balanceString = [self.balance stringNumberWithPowerOfMinus10:self.decimals];
	}
	return _balanceString;
}

- (NSString *)shortBalanceString {

	if (!self.balance || !self.decimals) {
		return @"";
	}

	if (!_shortBalanceString) {
		_shortBalanceString = [self.balance shortFormatOfNumberWithPowerOfMinus10:self.decimals];
	}
	return _shortBalanceString;
}

#pragma mark - Spendable

- (void)updateBalanceWithHandler:(void (^)(BOOL)) complete {

	[self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

- (void)updateHistoryWithHandler:(void (^)(BOOL)) complete andPage:(NSInteger) page {

	[self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

- (void)loadToMemory {

	_historyStorage = [HistoryDataStorage new];
	_historyStorage.spendableOwner = self;
}

- (void)historyDidChange {
	[self.manager spendableDidChange:self];
}

- (void)updateWithHandler:(void (^)(BOOL success)) complete {
	[self.manager updateSpendableObject:self];
}

#pragma  mark - NSCoder

static NSString *kContractName = @"name";
static NSString *kContractContractCreationAddressAddress = @"contractCreationAddressAddress";
static NSString *kContractLocalName = @"localName";
static NSString *kContractCreationDate = @"creationDate";
static NSString *kContractTemplateModel = @"templateModel";
static NSString *kContractAddress = @"contractAddress";
static NSString *kContractAdresses = @"adresses";
static NSString *kContractSymbol = @"symbol";
static NSString *kContractDecimals = @"decimals";
static NSString *kContractTotalSupply = @"totalSupply";
static NSString *kContractBalance = @"balance";
static NSString *kContractUnconfirmedBalance = @"unconfirmedBalance";
static NSString *kContractIsActive = @"isActive";
static NSString *kContractAddressWithBalanceDictionary = @"addressWithBalanceDictionary";

- (void)encodeWithCoder:(NSCoder *) aCoder {

	[aCoder encodeObject:self.name forKey:kContractName];
	[aCoder encodeObject:self.contractCreationAddressAddress forKey:kContractContractCreationAddressAddress];
	[aCoder encodeObject:self.localName forKey:kContractLocalName];
	[aCoder encodeObject:self.creationDate forKey:kContractCreationDate];
	[aCoder encodeObject:self.templateModel forKey:kContractTemplateModel];
	[aCoder encodeObject:self.contractAddress forKey:kContractAddress];
	[aCoder encodeObject:self.adresses forKey:kContractAdresses];
	[aCoder encodeObject:self.symbol forKey:kContractSymbol];
	[aCoder encodeObject:self.decimals forKey:kContractDecimals];
	[aCoder encodeObject:self.totalSupply forKey:kContractTotalSupply];
	[aCoder encodeObject:self.unconfirmedBalance.stringValue forKey:kContractUnconfirmedBalance];
	[aCoder encodeObject:@(self.isActive) forKey:kContractIsActive];
    [aCoder encodeObject:self.addressBalanceDictionary forKey:kContractAddressWithBalanceDictionary];
}

- (nullable instancetype)initWithCoder:(NSCoder *) aDecoder {

	NSString *name = [aDecoder decodeObjectForKey:kContractName];
	NSString *contractCreationAddressAddress = [aDecoder decodeObjectForKey:kContractContractCreationAddressAddress];
	NSString *localName = [aDecoder decodeObjectForKey:kContractLocalName];
	NSDate *creationDate = [aDecoder decodeObjectForKey:kContractCreationDate];
	TemplateModel *templateModel = [aDecoder decodeObjectForKey:kContractTemplateModel];
	NSString *contractAddress = [aDecoder decodeObjectForKey:kContractAddress];
	NSArray *adresses = [aDecoder decodeObjectForKey:kContractAdresses];
	NSString *symbol = [aDecoder decodeObjectForKey:kContractSymbol];
	QTUMBigNumber *decimals = [aDecoder decodeObjectForKey:kContractDecimals];
	QTUMBigNumber *totalSupply = [aDecoder decodeObjectForKey:kContractTotalSupply];
	BOOL isActive = [[aDecoder decodeObjectForKey:kContractIsActive] boolValue];
    NSDictionary *addressBalanceDictionary = [aDecoder decodeObjectForKey:kContractAddressWithBalanceDictionary];

	self = [super init];

	if (self) {

		_name = name;
		_contractCreationAddressAddress = contractCreationAddressAddress;
		_localName = localName;
		_creationDate = creationDate;
		_templateModel = templateModel;
		_contractAddress = contractAddress;
		_adresses = adresses;
		_symbol = symbol;
		_decimals = [decimals isKindOfClass:[NSNumber class]] ? [[QTUMBigNumber alloc] initWithString:[(NSNumber *)decimals stringValue]] : decimals;
		_totalSupply = [totalSupply isKindOfClass:[NSNumber class]] ? [[QTUMBigNumber alloc] initWithString:[(NSNumber *)decimals stringValue]] : totalSupply;
		_isActive = isActive;
        _addressBalanceDictionary = addressBalanceDictionary;
	}

	return self;
}

@end
