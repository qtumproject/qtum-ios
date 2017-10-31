//
//  JKBigDecimal+Format.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "JKBigDecimal+Format.h"
#import "NSNumber+Format.h"

@implementation JKBigDecimal (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(JKBigDecimal*) power {
    
    NSDecimalNumber* decimal = [[NSDecimalNumber alloc] initWithString:self.stringValue];
    NSDecimalNumber* decimalPower = [[NSDecimalNumber alloc] initWithString:power.stringValue];

    return [decimal shortFormatOfNumberWithPowerOfMinus10:decimalPower];
}

-(NSString*)shortFormatOfNumberWithPowerOf10:(JKBigDecimal*) power {
    
    NSDecimalNumber* decimal = [[NSDecimalNumber alloc] initWithString:self.stringValue];
    NSDecimalNumber* decimalPower = [[NSDecimalNumber alloc] initWithString:power.stringValue];
    
    return [decimal shortFormatOfNumberWithPowerOf10:decimalPower];
}

-(JKBigDecimal*)numberWithPowerOfMinus10:(JKBigDecimal*) power {
    
    JKBigDecimal* res = [self divide:[self tenInPower:power]];
    
    if ([res isKindOfClass:[JKBigDecimal class]]) {
        return res;
    }
    return nil;
}
-(JKBigDecimal*)numberWithPowerOf10:(JKBigDecimal*) power {
    
    JKBigDecimal* res = [self multiply:[self tenInPower:power]];
    
    if ([res isKindOfClass:[JKBigDecimal class]]) {
        return res;
    }
    return nil;
}

-(NSString*)stringNumberWithPowerOfMinus10:(JKBigDecimal*) power {
    
    JKBigDecimal* tenInPower = [self tenInPower:power];
    JKBigDecimal* res = [self divide:tenInPower];

    if ([res isKindOfClass:[JKBigDecimal class]] && ![res.stringValue isEqualToString:@"0"]) {
        return res.stringValue;
    } else {
        return [[NSDecimalNumber decimalNumberWithString:self.stringValue] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:tenInPower.stringValue]].stringValue;
    }
}

-(NSString*)stringNumberWithPowerOf10:(JKBigDecimal*) power {
    
    JKBigDecimal* res = [self multiply:[self tenInPower:power]];
    
    if ([res isKindOfClass:[JKBigDecimal class]]) {
        return res.stringValue;
    }
    
    return @"0";
}

-(NSString*)shortFormatOfNumber {
    
    NSDecimalNumber* decimal = [[NSDecimalNumber alloc] initWithString:self.stringValue];
    return [decimal shortFormatOfNumber];
}

-(JKBigDecimal*)tenInPower:(JKBigDecimal* )power {
    
    NSString* string = [power stringValue];
    return [[[JKBigDecimal alloc] initWithString:@"10"] pow:string.intValue];
}

@end
