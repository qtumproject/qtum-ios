//
//  JKBigDecimal+Comparison.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "JKBigDecimal.h"

@interface JKBigDecimal (Comparison)

- (BOOL)isLessThan:(JKBigDecimal *)decimalNumber;
- (BOOL)isLessThanOrEqualTo:(JKBigDecimal *)decimalNumber;
- (BOOL)isGreaterThan:(JKBigDecimal *)decimalNumber;
- (BOOL)isGreaterThanOrEqualTo:(JKBigDecimal *)decimalNumber;
- (BOOL)isEqualToDecimalNumber:(JKBigDecimal *)decimalNumber;
- (BOOL)isEqualToInt:(int)i;
- (BOOL)isGreaterThanInt:(int)i;
- (BOOL)isGreaterThanOrEqualToInt:(int)i;
- (BOOL)isLessThanInt:(int)i;
- (BOOL)isLessThanOrEqualToInt:(int)i;

- (NSDecimalNumber*)decimalNumber;
- (NSNumber*)roundedNumberWithScale:(NSInteger) scale;

@end
