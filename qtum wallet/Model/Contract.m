//
//  TokenModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "Contract.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "NSDate+Extension.h"
#import "NSNumber+Comparison.h"
#import "NSNumber+Format.h"

@implementation Contract

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _unconfirmedBalance = [[NSDecimalNumber alloc] initWithDouble:0];
    }
    return self;
}

-(NSString*)creationDateString {
    
    return self.creationDate ? [self.creationDate formatedDateString] : nil;
}

-(NSString*)creationFormattedDateString {
    
    return  self.creationDate ? [self.creationDate string] : nil;
}


#pragma mark - Getters 

-(NSString *)mainAddress {
    
    return self.contractAddress;
}

-(NSNumber *)totalSupply {
    
    return _totalSupply;
}

- (NSString*)totalSupplyString {
    
    NSDecimalNumber* decimal = [self.decimals decimalNumber];
    return [self.totalSupply stringNumberWithPowerOfMinus10:decimal];
}

- (NSString*)shortTotalSupplyString {
    
    NSDecimalNumber* decimal = [self.decimals decimalNumber];
    return [self.totalSupply shortFormatOfNumberWithPowerOfMinus10:decimal];
}

-(NSDecimalNumber*)balance {
    
    NSArray* values = self.addressBalanceDictionary.allValues;
    NSDecimalNumber* balanceDecimal = [[NSDecimalNumber alloc] initWithFloat:0];
    
    for (NSNumber* balanceValue in values) {
        
        if ([balanceValue isKindOfClass:[NSDecimalNumber class]]) {
            balanceDecimal = [balanceDecimal decimalNumberByAdding:(NSDecimalNumber*)balanceValue];
        } else {
            balanceDecimal = [balanceDecimal decimalNumberByAdding:balanceValue.decimalNumber];
        }
    }
    return balanceDecimal;
}

-(NSDictionary <NSString*,NSDecimalNumber*>*)addressBalanceDivByDecimalDictionary {
    
    NSDictionary <NSString*,NSDecimalNumber*>* addressBalanceDivByDecimalDictionary = @{}.mutableCopy;
    
    for (NSString* address in self.addressBalanceDictionary.allKeys) {
        
        [addressBalanceDivByDecimalDictionary setValue:[self.addressBalanceDictionary[address] numberWithPowerOfMinus10:[self.decimals decimalNumber]] forKey:address];
    }
    return addressBalanceDivByDecimalDictionary;
}

- (NSString*)balanceString {
    
    NSDecimalNumber* decimal = [self.decimals decimalNumber];
    return [self.balance stringNumberWithPowerOfMinus10:decimal];
}

- (NSString*)shortBalanceString {
    
    NSDecimalNumber* decimal = [self.decimals decimalNumber];
    return [self.balance shortFormatOfNumberWithPowerOfMinus10:decimal];
}

#pragma mark - Spendable

-(void)updateBalanceWithHandler:(void (^)(BOOL))complete {
    
    [self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

-(void)updateHistoryWithHandler:(void (^)(BOOL))complete andPage:(NSInteger) page {
    
    [self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

-(void)loadToMemory {
    
    _historyStorage = [HistoryDataStorage new];
    _historyStorage.spendableOwner = self;
}

-(void)historyDidChange{
    [self.manager spendableDidChange:self];
}

-(void)updateWithHandler:(void(^)(BOOL success)) complete{
    [self.manager updateSpendableObject:self];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.contractCreationAddressAddress forKey:@"contractCreationAddressAddress"];
    [aCoder encodeObject:self.addressBalanceDictionary forKey:@"addressBalanceDictionary"];
    [aCoder encodeObject:self.localName forKey:@"localName"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.templateModel forKey:@"templateModel"];
    [aCoder encodeObject:self.contractAddress forKey:@"contractAddress"];
    [aCoder encodeObject:self.adresses forKey:@"adresses"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.totalSupply forKey:@"totalSupply"];
    [aCoder encodeObject:self.balance forKey:@"balance"];
    [aCoder encodeObject:self.unconfirmedBalance forKey:@"unconfirmedBalance"];
    [aCoder encodeObject:@(self.isActive) forKey:@"isActive"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *contractCreationAddressAddress = [aDecoder decodeObjectForKey:@"contractCreationAddressAddress"];
    NSDictionary* addressBalanceDictionary = [aDecoder decodeObjectForKey:@"addressBalanceDictionary"];
    NSString *localName = [aDecoder decodeObjectForKey:@"localName"];
    NSDate *creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
    TemplateModel *templateModel = [aDecoder decodeObjectForKey:@"templateModel"];
    NSString *contractAddress = [aDecoder decodeObjectForKey:@"contractAddress"];
    NSArray *adresses = [aDecoder decodeObjectForKey:@"adresses"];
    NSString *symbol = [aDecoder decodeObjectForKey:@"symbol"];
    NSNumber *decimals = [aDecoder decodeObjectForKey:@"decimals"];
    NSNumber *totalSupply = [aDecoder decodeObjectForKey:@"totalSupply"];
    NSNumber *balance = [aDecoder decodeObjectForKey:@"balance"];
    NSNumber *unconfirmedBalance = [aDecoder decodeObjectForKey:@"unconfirmedBalance"];
    BOOL isActive = [[aDecoder decodeObjectForKey:@"isActive"] boolValue];
    
    self = [super init];
    
    if (self) {
        
        _name = name;
        _addressBalanceDictionary = addressBalanceDictionary;
        _contractCreationAddressAddress = contractCreationAddressAddress;
        _localName = localName;
        _creationDate = creationDate;
        _templateModel = templateModel;
        _contractAddress = contractAddress;
        _adresses = adresses;
        _symbol = symbol;
        _decimals = decimals;
        _totalSupply = totalSupply;
        _balance = [balance isKindOfClass:[NSDecimalNumber class]] ? (NSDecimalNumber*)balance : balance.decimalNumber;
        _unconfirmedBalance = [unconfirmedBalance isKindOfClass:[NSDecimalNumber class]] ? (NSDecimalNumber*)unconfirmedBalance : unconfirmedBalance.decimalNumber;
        _isActive = isActive;
    }
    
    return self;
}

@end
