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

@implementation Contract

-(void)setupWithHashTransaction:(NSString*) hash andAddresses:(NSArray*) addresses andTokenTemplate:(TemplateModel*) templateModel {
    
    NSMutableData* hashData = [[NSData reverseData:[NSString dataFromHexString:hash]] mutableCopy];
    uint32_t vinIndex = 0;
    [hashData appendBytes:&vinIndex length:1];
    hashData = [[hashData BTCHash160] mutableCopy];
    self.adresses = addresses;
    self.contractAddress = [NSString hexadecimalString:hashData];
    self.localName = [self.contractAddress substringToIndex:6];
    self.templateModel = templateModel;
    self.creationDate = [NSDate date];
    
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getTokenInfoWithDict:@{@"addressContract" : self.contractAddress} withSuccessHandler:^(id responseObject) {
        weakSelf.decimals = responseObject[@"decimals"];
        weakSelf.symbol = responseObject[@"symbol"];
        weakSelf.name = responseObject[@"name"];
        weakSelf.totalSupply = responseObject[@"totalSupply"];
        weakSelf.balance = [responseObject[@"totalSupply"] floatValue];
        [weakSelf.delegate tokenDidChange:weakSelf];
    } andFailureHandler:^(NSError *error, NSString *message) {
        NSLog(@"Error -> %@", error);
    }];
}

-(void)setupWithContractAddresse:(NSString*) contractAddresse {

    self.contractAddress = contractAddresse;
    self.creationDate = [NSDate date];
    self.localName = [self.contractAddress substringToIndex:6];
    self.adresses = [[[WalletManager sharedInstance] getHashTableOfKeys] allKeys];
}

-(NSString*)creationDateString {
    
    return self.creationDate ? [self.creationDate formatedDateString] : nil;
}


#pragma mark - Getters 

-(NSString *)mainAddress {
    
    return self.contractAddress;
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
-(void)updateHandler:(void(^)(BOOL success)) complete{
    [self.manager updateSpendableObject:self];
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.localName forKey:@"localName"];
    [aCoder encodeObject:self.creationDate forKey:@"creationDate"];
    [aCoder encodeObject:self.templateModel forKey:@"templateModel"];
    [aCoder encodeObject:self.contractAddress forKey:@"contractAddress"];
    [aCoder encodeObject:self.adresses forKey:@"adresses"];
    [aCoder encodeObject:self.symbol forKey:@"symbol"];
    [aCoder encodeObject:self.decimals forKey:@"decimals"];
    [aCoder encodeObject:self.totalSupply forKey:@"totalSupply"];
    [aCoder encodeObject:@(self.balance) forKey:@"balance"];
    [aCoder encodeObject:@(self.unconfirmedBalance) forKey:@"unconfirmedBalance"];
    [aCoder encodeObject:@(self.isActive) forKey:@"isActive"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *name = [aDecoder decodeObjectForKey:@"name"];
    NSString *localName = [aDecoder decodeObjectForKey:@"localName"];
    NSDate *creationDate = [aDecoder decodeObjectForKey:@"creationDate"];
    TemplateModel *templateModel = [aDecoder decodeObjectForKey:@"templateModel"];
    NSString *contractAddress = [aDecoder decodeObjectForKey:@"contractAddress"];
    NSArray *adresses = [aDecoder decodeObjectForKey:@"adresses"];
    NSString *symbol = [aDecoder decodeObjectForKey:@"symbol"];
    NSString *decimals = [aDecoder decodeObjectForKey:@"decimals"];
    NSString *totalSupply = [aDecoder decodeObjectForKey:@"totalSupply"];
    CGFloat balance = [[aDecoder decodeObjectForKey:@"balance"] floatValue];
    CGFloat unconfirmedBalance = [[aDecoder decodeObjectForKey:@"unconfirmedBalance"] floatValue];
    BOOL isActive = [[aDecoder decodeObjectForKey:@"isActive"] boolValue];
    
    self = [super init];
    if (self) {
        self.name = name;
        self.localName = localName;
        self.creationDate = creationDate;
        self.templateModel = templateModel;
        self.contractAddress = contractAddress;
        self.adresses = adresses;
        self.symbol = symbol;
        self.decimals = decimals;
        self.totalSupply = totalSupply;
        self.balance = balance;
        self.unconfirmedBalance = unconfirmedBalance;
        self.isActive = isActive;
    }
    
    return self;
}

@end
