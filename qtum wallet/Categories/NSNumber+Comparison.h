//
//  NSNumber+Comparison.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich  on 25.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDecimalNumber+Comparison.h"


@interface NSNumber (Comparison)

- (BOOL)isLessThan:(NSNumber *) decimalNumber;

- (BOOL)isLessThanOrEqualTo:(NSNumber *) decimalNumber;

- (BOOL)isGreaterThan:(NSNumber *) decimalNumber;

- (BOOL)isGreaterThanOrEqualTo:(NSNumber *) decimalNumber;

- (BOOL)isEqualToDecimalNumber:(NSNumber *) decimalNumber;

- (BOOL)isEqualToInt:(int) i;

- (BOOL)isGreaterThanInt:(int) i;

- (BOOL)isGreaterThanOrEqualToInt:(int) i;

- (BOOL)isLessThanInt:(int) i;

- (BOOL)isLessThanOrEqualToInt:(int) i;

- (NSDecimalNumber *)decimalNumber;

- (NSDecimalNumber *)roundedNumberWithScale:(NSInteger) scale;

@end
