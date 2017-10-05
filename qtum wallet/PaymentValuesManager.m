//
//  PaymentValuesManager.m
//  qtum wallet
//
//  Created by Vladimir Sharaev on 04.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PaymentValuesManager.h"

NSString *const PaymentValuesManagerFeeKey = @"PaymentValuesManagerFeeKey";
NSString *const PaymentValuesManagerGasPriceKey = @"PaymentValuesManagerGasPriceKey";
NSString *const PaymentValuesManagerGaslimitKey = @"PaymentValuesManagerGaslimitKey";

long const MaxFee = 1;

long const StandartGasLimitForCreateContract = 2000000;
long const StandartGasLimit = 200000;
long const MinGasLimit = 100000;
long const MinGasPrice = 40;

long const GasPriceStep = 5;
long const GasPriceStepsCount = 16;
long const GasLimitStep = 100000;
long const GasLimitStepsCount = 49;

@interface PaymentValuesManager()

@property (nonatomic) NSNumber *gasPrice;
@property (nonatomic) NSNumber *gasLimit;
@property (nonatomic) NSNumber *fee;

@end

@implementation PaymentValuesManager

+ (instancetype)sharedInstance {
    static PaymentValuesManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    if (self != nil) {
        _minGasLimit = @(MinGasLimit);
        _minGasPrice = @(MinGasPrice);
        _maxFee = @(MaxFee);
        _standartGasLimit = @(StandartGasLimit);
        _standartGasLimitForCreateContract = @(StandartGasLimitForCreateContract);
        [self calculateMaxValues];
        
        [self loadLastValues];
        [self loadDGPInfo];
    }
    return self;
}

- (void)saveLastValues {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.fee forKey:PaymentValuesManagerFeeKey];
    [userDefaults setObject:self.gasPrice forKey:PaymentValuesManagerGasPriceKey];
    [userDefaults setObject:self.gasLimit forKey:PaymentValuesManagerGaslimitKey];
    [userDefaults synchronize];
}

- (void)loadLastValues {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *fee = [userDefaults objectForKey:PaymentValuesManagerFeeKey];
    NSNumber *gasPrice = [userDefaults objectForKey:PaymentValuesManagerGasPriceKey];
    NSNumber *gasLimit = [userDefaults objectForKey:PaymentValuesManagerGaslimitKey];
    
    if (fee) _fee = fee;
    if (gasPrice) _gasPrice = gasPrice;
    if (gasLimit) _gasLimit = gasLimit;
}

- (void)calculateMaxValues {
    _maxGasPrice = @([self.minGasPrice longValue] + GasPriceStep * GasPriceStepsCount);
    _maxGasLimit = @([self.minGasLimit longValue] + GasLimitStep * GasLimitStepsCount);
}

- (void)loadDGPInfo {
    __weak typeof(self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getDGPinfo:^(id responseObject) {
        NSDictionary *dictionary = (NSDictionary *)responseObject;
    
        weakSelf.minGasPrice = [dictionary objectForKey:@"mingasprice"];

        [weakSelf calculateMaxValues];
    } andFailureHandler:^(NSError *error, NSString *message) {
        DLog(@"Cannot get DGP info");
    }];
}

@end
