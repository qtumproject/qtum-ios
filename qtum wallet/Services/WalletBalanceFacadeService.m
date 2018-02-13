//
//  WalletBalanceFacadeService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "WalletBalanceFacadeService.h"
#import "WalletBalanceEntity+Extension.h"

@interface WalletBalanceFacadeService ()

@property (strong, nonatomic) id <Requestable> requestManager;
@property (strong, nonatomic) CoreDataService* storageService;
@property (strong, nonatomic) WalletBalanceEntity* balances;
@property (copy, nonatomic) WalletBalanceHendler delegateHandler;

@end

@implementation WalletBalanceFacadeService

- (instancetype)initWithRequestService:(id <Requestable>) requestManager andStorageService:(CoreDataService*) storageService {
    
    self = [super init];
    
    if (self) {
        _requestManager = requestManager;
        _storageService = storageService;
        [self setupWalletBalance];
    }
    
    return self;
}

-(WalletBalanceEntity*)balances {
    
    if (!_balances) {
        [self setupWalletBalance];
    }
    return _balances;
}

-(void)setupWalletBalance {
    
    WalletBalanceEntity* balance = [self.storageService walletBalanceEntity];
    
    if (!balance.dateInterval) {
        balance.dateInterval = [[NSDate new] timeIntervalSince1970];
    }
    
    self.balances = balance;
}

- (QTUMBigNumber*)lastBalance {
    return self.balances.balance;
}

- (QTUMBigNumber*)lastUnconfirmedBalance {
    return self.balances.unconfirmedBalance;
}

- (NSString*)lastUpdateDateSring {
    return self.balances.fullDateString;
}

- (void)updateBalansesWithObject:(NSDictionary *) dataDictionary withHandler:(WalletBalanceHendler) handler;{
    
    NSNumber *balance = dataDictionary[@"balance"];
    NSNumber *unconfirmedBalance = dataDictionary[@"unconfirmedBalance"];
    
    if ([balance isKindOfClass:[NSNumber class]]) {
        self.balances.balanceString = balance.stringValue;
    }
    
    if ([unconfirmedBalance isKindOfClass:[NSNumber class]]) {
        self.balances.unconfirmedBalanceString = unconfirmedBalance.stringValue;
    }
    
    self.balances.dateInterval = [[NSDate new] timeIntervalSince1970];
    
    [self.storageService saveWithcompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        handler(contextDidSave);
    }];
}

- (void)updateForAddreses:(NSArray *) keyAddreses withHandler:(WalletBalanceHendler) handler {
    
    __weak __typeof (self) weakSelf = self;
    self.delegateHandler = handler;
    [self.requestManager getUnspentOutputsForAdreses:keyAddreses isAdaptive:YES successHandler:^(id responseObject) {
        [weakSelf updateWithBalance:responseObject];
    } andFailureHandler:^(NSError *error, NSString *message) {
        handler(NO);
    }];
    
}

- (void)updateWithBalance:(NSArray *) responseObject {
    
    QTUMBigNumber *balance = [QTUMBigNumber decimalWithInteger:0];
    __weak __typeof (self) weakSelf = self;

    for (NSDictionary *dictionary in responseObject) {
        
        NSNumber *amount = dictionary[@"amount"];
        if ([amount isKindOfClass:[NSNumber class]]) {
            balance = [balance add:[QTUMBigNumber decimalWithString:amount.stringValue]];
        }
    }
    
    self.balances.balanceString = balance.stringValue;
    
    [self.storageService saveWithcompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (weakSelf.delegateHandler) {
            weakSelf.delegateHandler(YES);
        }
    }];
}

-(void)clear {
    self.balances = nil;
    self.delegateHandler = nil;
}

@end
