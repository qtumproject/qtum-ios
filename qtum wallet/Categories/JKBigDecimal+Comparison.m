//
//  JKBigDecimal+Comparison.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "JKBigDecimal+Comparison.h"

@implementation JKBigDecimal (Comparison)

- (BOOL)isLessThan:(JKBigDecimal *)decimalNumber {
    return [self compare:decimalNumber] == NSOrderedAscending;
}

- (BOOL)isLessThanOrEqualTo:(JKBigDecimal *)decimalNumber {
    return [self compare:decimalNumber] != NSOrderedDescending;
}

- (BOOL)isGreaterThan:(JKBigDecimal *)decimalNumber {
    return [self compare:decimalNumber] == NSOrderedDescending;
}

- (BOOL)isGreaterThanOrEqualTo:(JKBigDecimal *)decimalNumber {
    return [self compare:decimalNumber] != NSOrderedAscending;
}

- (BOOL)isEqualToDecimalNumber:(JKBigDecimal *)decimalNumber {
    
    return [self compare:decimalNumber] == NSOrderedSame;
}

- (NSComparisonResult) compareWithInt:(int)i {
    
    return [self compare:[[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%i", i]]];
}

- (BOOL) isEqualToInt:(int)i{
    return [self compareWithInt:i] == NSOrderedSame;
}

- (BOOL) isGreaterThanInt:(int)i{
    return [self compareWithInt:i] == NSOrderedDescending;
}

- (BOOL) isGreaterThanOrEqualToInt:(int)i{
    return [self isGreaterThanInt:i] || [self isEqualToInt:i];
}

- (BOOL) isLessThanInt:(int)i{
    return [self compareWithInt:i] == NSOrderedAscending;
}

- (BOOL) isLessThanOrEqualToInt:(int)i{
    return [self isLessThanInt:i] || [self isEqualToInt:i];
}

#pragma mark - Converting

- (NSDecimalNumber*)decimalNumber {
    
    if ([self isKindOfClass:[NSDecimalNumber class]]) {
        return (NSDecimalNumber*)self;
    } else {
        return [NSDecimalNumber decimalNumberWithString:self.stringValue];
    }
}

- (NSNumber*)roundedNumberWithScale:(NSInteger) scale {
    
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                                                              scale:scale
                                                                                   raiseOnExactness:NO
                                                                                    raiseOnOverflow:NO
                                                                                   raiseOnUnderflow:NO
                                                                                raiseOnDivideByZero:NO];
    return [self.decimalNumber decimalNumberByRoundingAccordingToBehavior:behavior];
}

@end
