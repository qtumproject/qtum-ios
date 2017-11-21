//
//  PaymentValuesManager.h
//  qtum wallet
//
//  Created by Vladimir Sharaev on 04.10.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern long const GasPriceStep;
extern long const GasLimitStep;

@interface PaymentValuesManager : NSObject

@property (nonatomic) QTUMBigNumber *maxFee;
@property (nonatomic) QTUMBigNumber *standartGasLimit;
@property (nonatomic) QTUMBigNumber *standartGasLimitForCreateContract;
@property (nonatomic) QTUMBigNumber *minGasLimit;
@property (nonatomic) QTUMBigNumber *minGasPrice;
@property (nonatomic) QTUMBigNumber *maxGasLimit;
@property (nonatomic) QTUMBigNumber *maxGasPrice;

- (void)loadDGPInfo;

@end
