//
//  PaymentValuesManager.m
//  qtum wallet
//
//  Created by Vladimir Sharaev on 04.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

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

@interface PaymentValuesManager ()

@property (nonatomic) QTUMBigNumber *gasPrice;
@property (nonatomic) QTUMBigNumber *gasLimit;
@property (nonatomic) QTUMBigNumber *fee;

@end

@implementation PaymentValuesManager

- (instancetype)init {

	self = [super init];
	if (self != nil) {
		_minGasLimit = [QTUMBigNumber decimalWithInteger:MinGasLimit];
		_minGasPrice = [QTUMBigNumber decimalWithInteger:MinGasPrice];
		_maxFee = [QTUMBigNumber decimalWithInteger:MaxFee];
		_standartGasLimit = [QTUMBigNumber decimalWithInteger:StandartGasLimit];
		_standartGasLimitForCreateContract = [QTUMBigNumber decimalWithInteger:StandartGasLimitForCreateContract];
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
	QTUMBigNumber *fee = [userDefaults objectForKey:PaymentValuesManagerFeeKey];
	QTUMBigNumber *gasPrice = [userDefaults objectForKey:PaymentValuesManagerGasPriceKey];
	QTUMBigNumber *gasLimit = [userDefaults objectForKey:PaymentValuesManagerGaslimitKey];

	if (fee)
		_fee = fee;
	if (gasPrice)
		_gasPrice = gasPrice;
	if (gasLimit)
		_gasLimit = gasLimit;
}

- (void)calculateMaxValues {

	_maxGasPrice = [QTUMBigNumber decimalWithInteger:[self.minGasPrice integerValue] + GasPriceStep * GasPriceStepsCount];
	_maxGasLimit = [QTUMBigNumber decimalWithInteger:[self.minGasLimit integerValue] + GasLimitStep * GasLimitStepsCount];
}

- (void)loadDGPInfo {
	__weak typeof (self) weakSelf = self;
	[SLocator.requestManager getDGPinfo:^(id responseObject) {
		NSDictionary *dictionary = (NSDictionary *)responseObject;

		NSNumber *mingasprice = [dictionary objectForKey:@"mingasprice"];
		weakSelf.minGasPrice = [QTUMBigNumber decimalWithString:mingasprice.stringValue];

		[weakSelf calculateMaxValues];
	}                 andFailureHandler:^(NSError *error, NSString *message) {
		DLog(@"Cannot get DGP info");
	}];
}

@end
