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

@property (nonatomic) NSNumber *maxFee;
@property (nonatomic) NSNumber *standartGasLimit;
@property (nonatomic) NSNumber *standartGasLimitForCreateContract;
@property (nonatomic) NSNumber *minGasLimit;
@property (nonatomic) NSNumber *minGasPrice;
@property (nonatomic) NSNumber *maxGasLimit;
@property (nonatomic) NSNumber *maxGasPrice;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)loadDGPInfo;

@end
