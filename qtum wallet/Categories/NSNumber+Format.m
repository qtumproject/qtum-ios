//
//  NSNumber+Format.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSNumber+Format.h"
#import "NSNumber+Comparison.h"

@implementation NSNumber (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:10 raiseOnExactness:YES raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    if (powerDecimal) {
        NSString* str = [[numberDecimal decimalNumberByMultiplyingByPowerOf10: -powerDecimal.shortValue withBehavior:roundUp] shortFormatOfNumber];
        return str;
    }
    
    return [self shortFormatOfNumber];
}

-(NSString*)shortFormatOfNumberWithPowerOf10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    if (powerDecimal) {
        
        return [[numberDecimal decimalNumberByMultiplyingByPowerOf10: powerDecimal.shortValue] shortFormatOfNumber];
    }
    
    return [self shortFormatOfNumber];
}

-(NSString*)shortFormatOfNumber {
    
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setExponentSymbol:@"E"];
    [fmt setPositiveFormat:@"0.##E+0"];
    
    return [fmt stringFromNumber:numberDecimal];
}

-(NSDecimalNumber*)numberWithPowerOfMinus10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    if (powerDecimal) {
        return [numberDecimal decimalNumberByMultiplyingByPowerOf10: -powerDecimal.shortValue];
    }
    return numberDecimal;
}

-(NSDecimalNumber*)numberWithPowerOf10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    if (powerDecimal && ![numberDecimal isEqual:[NSDecimalNumber notANumber]] && ![powerDecimal isEqual:[NSDecimalNumber notANumber]]) {
        return [numberDecimal decimalNumberByMultiplyingByPowerOf10: powerDecimal.shortValue];
    }
    
    return numberDecimal;
}

-(NSString*)stringNumberWithPowerOf10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    if (powerDecimal) {
        return [[numberDecimal decimalNumberByMultiplyingByPowerOf10: powerDecimal.shortValue] stringValue];
    }
    return numberDecimal.stringValue;
}

-(NSString*)stringNumberWithPowerOfMinus10:(NSNumber*) power {
    
    NSDecimalNumber* powerDecimal = [power decimalNumber];
    NSDecimalNumber* numberDecimal = [self decimalNumber];
    
    if (powerDecimal) {
        return [[numberDecimal decimalNumberByMultiplyingByPowerOf10: -powerDecimal.shortValue] stringValue];
    }
    return numberDecimal.stringValue;
}

@end
