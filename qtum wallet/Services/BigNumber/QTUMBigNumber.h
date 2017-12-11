//
//  QTUMBigNumber.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKBigDecimal.h"

@interface QTUMBigNumber : NSObject

@property (strong, nonatomic, readonly) JKBigDecimal *decimalContainer;

+ (instancetype)decimalWithString:(NSString *) string;

+ (instancetype)decimalWithInteger:(NSInteger) integer;

- (instancetype)initWithString:(NSString *) string;

- (instancetype)initWithInteger:(NSInteger) integer;


- (instancetype)add:(QTUMBigNumber *) bigDecimal;

- (instancetype)subtract:(QTUMBigNumber *) bigDecimal;

- (instancetype)multiply:(QTUMBigNumber *) bigDecimal;

- (instancetype)divide:(QTUMBigNumber *) bigDecimal;

- (instancetype)remainder:(QTUMBigNumber *) bigInteger;

- (NSComparisonResult)compare:(QTUMBigNumber *) other;

- (instancetype)pow:(unsigned int) exponent;

- (instancetype)negate;

- (instancetype)abs;

- (NSString *)stringValue;

- (NSInteger)integerValue;

- (NSString *)description;

- (int64_t)satoshiAmountValue;

- (NSInteger)qtumAmountValue;

@end

@interface QTUMBigNumber (Comparison)

- (BOOL)isLessThan:(QTUMBigNumber *) decimalNumber;

- (BOOL)isLessThanOrEqualTo:(QTUMBigNumber *) decimalNumber;

- (BOOL)isGreaterThan:(QTUMBigNumber *) decimalNumber;

- (BOOL)isGreaterThanOrEqualTo:(QTUMBigNumber *) decimalNumber;

- (BOOL)isEqualToDecimalNumber:(QTUMBigNumber *) decimalNumber;

- (BOOL)isEqualToInt:(int) i;

- (BOOL)isGreaterThanInt:(int) i;

- (BOOL)isGreaterThanOrEqualToInt:(int) i;

- (BOOL)isLessThanInt:(int) i;

- (BOOL)isLessThanOrEqualToInt:(int) i;

- (NSDecimalNumber *)decimalNumber;

- (QTUMBigNumber *)roundedNumberWithScale:(NSInteger) scale;

@end

@interface QTUMBigNumber (Format)

- (NSString *)shortFormatOfNumberWithPowerOfMinus10:(QTUMBigNumber *) power;

- (NSString *)shortFormatOfNumberWithPowerOf10:(QTUMBigNumber *) power;

- (QTUMBigNumber *)numberWithPowerOfMinus10:(QTUMBigNumber *) power;

- (QTUMBigNumber *)numberWithPowerOf10:(QTUMBigNumber *) power;

- (NSString *)stringNumberWithPowerOfMinus10:(QTUMBigNumber *) power;

- (NSString *)stringNumberWithPowerOf10:(QTUMBigNumber *) power;

- (NSString *)shortFormatOfNumber;

@end

@interface QTUMBigNumber (Constants)

+ (QTUMBigNumber*)maxBigNumberWithPowerOfTwo:(NSInteger) power isUnsigned:(BOOL) isUnsigned;

@end
