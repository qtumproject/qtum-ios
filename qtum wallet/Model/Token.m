//
//  TokenModel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "Token.h"
#import "NSString+Extension.h"
#import "NSData+Extension.h"

@implementation Token

-(void)setupWithHashTransaction:(NSString*) hash andAddresses:(NSArray*) addresses{
    
    NSMutableData* hashData = [[NSData reverseData:[NSString dataFromHexString:hash]] mutableCopy];
    uint32_t vinIndex = 0;
    [hashData appendBytes:&vinIndex length:1];
    hashData = [[hashData BTCHash160] mutableCopy];
    self.adresses = addresses;
    self.contractAddress = [NSString hexadecimalString:hashData];
    
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getTokenInfoWithDict:@{@"addressContract" : self.contractAddress} withSuccessHandler:^(id responseObject) {
        weakSelf.decimals = responseObject[@"decimals"];
        weakSelf.symbol = responseObject[@"symbol"];
        weakSelf.name = responseObject[@"name"];
        weakSelf.totalSupply = responseObject[@"totalSupply"];
        [weakSelf.delegate tokenDidChange:weakSelf];
    } andFailureHandler:^(NSError *error, NSString *message) {
        NSLog(@"Error -> %@", error);
    }];
}


#pragma mark - Getters 

-(NSString *)mainAddress{
    return self.contractAddress;
}

#pragma mark - Spendable

-(void)updateBalanceWithHandler:(void (^)(BOOL))complete{
    [self.manager updateBalanceOfSpendableObject:self withHandler:complete];
}

-(void)updateHistoryWithHandler:(void (^)(BOOL))complete andPage:(NSInteger) page{
    [self.manager updateHistoryOfSpendableObject:self withHandler:complete andPage:page];
}

-(void)loadToMemory{
    _historyStorage = [HistoryDataStorage new];
    _historyStorage.spendableOwner = self;
}

-(void)historyDidChange{
    [self.manager spendableDidChange:self];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.contractAddress forKey:@"contractAddress"];
    [aCoder encodeObject:self.adresses forKey:@"adresses"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.totalSupply forKey:@"totalSupply"];
    [aCoder encodeObject:@(self.balance) forKey:@"balance"];
    [aCoder encodeObject:@(self.unconfirmedBalance) forKey:@"unconfirmedBalance"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *contractAddress = [aDecoder decodeObjectForKey:@"contractAddress"];
    NSArray *adresses = [aDecoder decodeObjectForKey:@"adresses"];
    NSString *symbol = [aDecoder decodeObjectForKey:@"symbol"];
    NSString *decimals = [aDecoder decodeObjectForKey:@"decimals"];
    NSString *totalSupply = [aDecoder decodeObjectForKey:@"totalSupply"];
    CGFloat balance = [[aDecoder decodeObjectForKey:@"balance"] floatValue];
    CGFloat unconfirmedBalance = [[aDecoder decodeObjectForKey:@"unconfirmedBalance"] floatValue];
    
    self = [super init];
    if (self) {
        self.name = name;
        self.contractAddress = contractAddress;
        self.adresses = adresses;
        self.symbol = symbol;
        self.decimals = decimals;
        self.totalSupply = totalSupply;
        self.balance = balance;
        self.unconfirmedBalance = unconfirmedBalance;
    }
    
    return self;
}

@end
