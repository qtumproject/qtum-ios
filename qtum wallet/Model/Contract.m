//
//  TokenModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "Contract.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"
#import "NSDate+Extension.h"
#import "QTUMBigNumber.h"

@interface Contract ()

@property (strong, nonatomic) NSString* balanceString;
@property (strong, nonatomic) NSString* shortBalanceString;
@property (strong, nonatomic) NSString* totalSupplyString;
@property (strong, nonatomic) NSString* shortTotalSupplyString;

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

-(void)setAddressBalanceDictionary:(NSDictionary<NSString *,QTUMBigNumber *> *)addressBalanceDictionary {
    
    self.balance = nil;
    self.balanceString = nil;
    self.shortBalanceString = nil;
    _addressBalanceDictionary = addressBalanceDictionary;
}

-(NSString*)creationDateString {
    
    return self.creationDate ? [self.creationDate formatedDateString] : nil;
}

-(NSString*)creationFormattedDateString {
    
    return  self.creationDate ? [self.creationDate string] : nil;
}

-(NSString *)mainAddress {
    
    return self.contractAddress;
}

- (NSString*)totalSupplyString {
    
    if (!_totalSupplyString) {
        _totalSupplyString = [self.totalSupply stringNumberWithPowerOfMinus10:self.decimals];
    }
    return _totalSupplyString;
}

- (NSString*)shortTotalSupplyString {
    
    if (!_shortTotalSupplyString) {
        _shortTotalSupplyString = [self.totalSupply shortFormatOfNumberWithPowerOfMinus10:self.decimals];
    }
    return _shortTotalSupplyString;
}

-(QTUMBigNumber*)balance {
    
    if (!_balance) {
        NSArray* values = self.addressBalanceDictionary.allValues;
        QTUMBigNumber* balanceDecimal = [[QTUMBigNumber alloc] initWithString:@"0"];
        
        for (QTUMBigNumber* balanceValue in values) {
            
            balanceDecimal = [balanceDecimal add:balanceValue];
        }
        _balance = balanceDecimal;
    }

    return _balance;
}

-(NSDictionary <NSString*,NSDictionary<NSString*,NSString*>*>*)addressBalanceDivByDecimalDictionary {
    
    NSDictionary <NSString*,NSDictionary<NSString*,NSString*>*>* addressBalanceDivByDecimalDictionary = @{}.mutableCopy;
    
    for (NSString* address in self.addressBalanceDictionary.allKeys) {
        
        [addressBalanceDivByDecimalDictionary setValue:@{@"longString" : [self.addressBalanceDictionary[address] stringNumberWithPowerOfMinus10:self.decimals],
                                                         @"shortString" : [self.addressBalanceDictionary[address] shortFormatOfNumberWithPowerOfMinus10:self.decimals]
                                                         } forKey:address];
    }
    return addressBalanceDivByDecimalDictionary;
}

- (NSString*)balanceString {
    
    if (!_balanceString) {
        _balanceString = [self.balance stringNumberWithPowerOfMinus10:self.decimals];
    }
    return _balanceString;
}

- (NSString*)shortBalanceString {
    
    if (!_shortBalanceString) {
        _shortBalanceString = [self.balance shortFormatOfNumberWithPowerOfMinus10:self.decimals];
    }
    return _shortBalanceString;
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

-(void)historyDidChange {
    [self.manager spendableDidChange:self];
}

-(void)updateWithHandler:(void(^)(BOOL success)) complete{
    [self.manager updateSpendableObject:self];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.contractCreationAddressAddress forKey:@"contractCreationAddressAddress"];
    [aCoder encodeObject:self.localName forKey:@"localName"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.templateModel forKey:@"templateModel"];
    [aCoder encodeObject:self.contractAddress forKey:@"contractAddress"];
    [aCoder encodeObject:self.adresses forKey:@"adresses"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.totalSupply forKey:@"totalSupply"];
    [aCoder encodeObject:self.balance.stringValue forKey:@"balance"];
    [aCoder encodeObject:self.unconfirmedBalance.stringValue forKey:@"unconfirmedBalance"];
    [aCoder encodeObject:@(self.isActive) forKey:@"isActive"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *contractCreationAddressAddress = [aDecoder decodeObjectForKey:@"contractCreationAddressAddress"];
    NSString *localName = [aDecoder decodeObjectForKey:@"localName"];
    NSDate *creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
    TemplateModel *templateModel = [aDecoder decodeObjectForKey:@"templateModel"];
    NSString *contractAddress = [aDecoder decodeObjectForKey:@"contractAddress"];
    NSArray *adresses = [aDecoder decodeObjectForKey:@"adresses"];
    NSString *symbol = [aDecoder decodeObjectForKey:@"symbol"];
    QTUMBigNumber *decimals = [aDecoder decodeObjectForKey:@"decimals"];
    QTUMBigNumber *totalSupply = [aDecoder decodeObjectForKey:@"totalSupply"];
    BOOL isActive = [[aDecoder decodeObjectForKey:@"isActive"] boolValue];
    
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
        _decimals = [decimals isKindOfClass:[NSNumber class]] ? [[QTUMBigNumber alloc] initWithString:[(NSNumber*)_decimals stringValue]] : decimals;
        _totalSupply = [totalSupply isKindOfClass:[NSNumber class]] ? [[QTUMBigNumber alloc] initWithString:[(NSNumber*)_totalSupply stringValue]] : totalSupply;
        _isActive = isActive;
    }
    
    return self;
}

@end
