//
//  NSNumber+Comparison.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich  on 25.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSNumber+Comparison.h"

@implementation NSNumber (Comparison)

- (BOOL)isLessThan:(NSNumber *)number {
    
    NSDecimalNumber* selfDecimal = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    NSDecimalNumber* numberDecimal = [NSDecimalNumber decimalNumberWithString:number.stringValue];

    return [selfDecimal isLessThan:numberDecimal];
}

- (BOOL)isLessThanOrEqualTo:(NSNumber *)number {
    
    NSDecimalNumber* selfDecimal = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    NSDecimalNumber* numberDecimal = [NSDecimalNumber decimalNumberWithString:number.stringValue];
    
    return [selfDecimal isLessThanOrEqualTo:numberDecimal];
}

- (BOOL)isGreaterThan:(NSNumber *)number {
    
    NSDecimalNumber* selfDecimal = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    NSDecimalNumber* numberDecimal = [NSDecimalNumber decimalNumberWithString:number.stringValue];
    
    return [selfDecimal isGreaterThan:numberDecimal];
}

- (BOOL)isGreaterThanOrEqualTo:(NSNumber *)number {
    
    NSDecimalNumber* selfDecimal = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    NSDecimalNumber* numberDecimal = [NSDecimalNumber decimalNumberWithString:number.stringValue];
    
    return [selfDecimal isGreaterThanOrEqualTo:numberDecimal];
}

- (BOOL)isEqualToDecimalNumber:(NSNumber *)number {
    
    NSDecimalNumber* selfDecimal = [NSDecimalNumber decimalNumberWithString:self.stringValue];
    NSDecimalNumber* numberDecimal = [NSDecimalNumber decimalNumberWithString:number.stringValue];
    
    return [selfDecimal isEqualToDecimalNumber:numberDecimal];
}

- (NSComparisonResult) compareWithInt:(int)i{
    return [self compare:[NSNumber numberWithInt:i]];
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
