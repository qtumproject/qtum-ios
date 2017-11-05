//
//  QTUMBigNumber.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMBigNumber.h"
#import "JKBigDecimal+Comparison.h"
#import "JKBigDecimal+Format.h"
#import "NSDecimalNumber+Comparison.h"
#import "NSNumber+Format.h"

@interface QTUMBigNumber ()

@property (copy, nonatomic) NSString* stringNumberValue;
@property (strong, nonatomic) JKBigDecimal* decimalContainer;

@end

@implementation QTUMBigNumber

- (instancetype)initWithString:(NSString *)string {
    
    self = [super init];
    
    if (self) {
        
        NSString* formattedString = [string stringByReplacingOccurrencesOfString:@"," withString:@"."];
        _stringNumberValue = formattedString;
        _decimalContainer = [[JKBigDecimal alloc] initWithString:formattedString];
    }
    return self;
}

- (instancetype)initWithInteger:(NSInteger) integer {
    
    NSString* intString = [NSString stringWithFormat:@"%li",integer];
    return [self initWithString:intString];
}

#pragma mark - Custom Accessors

-(JKBigInteger*)bigInteger {
    return self.decimalContainer.bigInteger;
}

-(NSUInteger)figure {
    return self.decimalContainer.figure;
}

- (NSInteger)integerValue {
    
    return (NSInteger)[self.decimalNumber doubleValue];
}


#pragma mark - Public

+ (instancetype)decimalWithString:(NSString *)string {
    
    QTUMBigNumber* decimal = [[QTUMBigNumber alloc] initWithString:string];
    return decimal;
}

+ (instancetype)decimalWithInteger:(NSInteger)integer {
    
    NSString* intString = [NSString stringWithFormat:@"%li",integer];
    QTUMBigNumber* decimal = [[QTUMBigNumber alloc] initWithString:intString];
    return decimal;
}


- (instancetype)add:(QTUMBigNumber *)bigDecimal {
    
    NSDecimalNumber* resDecimal = [[self.decimalContainer decimalNumber] decimalNumberByAdding:[bigDecimal decimalNumber]];
    QTUMBigNumber* res = [QTUMBigNumber decimalWithString:resDecimal.stringValue];
    return res;
}

- (instancetype)subtract:(QTUMBigNumber *)bigDecimal {
    
    NSDecimalNumber* resDecimal = [[self.decimalContainer decimalNumber] decimalNumberBySubtracting:[bigDecimal decimalNumber]];
    QTUMBigNumber* res = [QTUMBigNumber decimalWithString:resDecimal.stringValue];
    return res;
}

- (instancetype)multiply:(QTUMBigNumber *)bigDecimal {
    
    NSDecimalNumber* resDecimal = [[self.decimalContainer decimalNumber] decimalNumberByMultiplyingBy:[bigDecimal decimalNumber]];
    QTUMBigNumber* res = [QTUMBigNumber decimalWithString:resDecimal.stringValue];
    return res;
}

- (instancetype)divide:(QTUMBigNumber *)bigDecimal {
    
    NSDecimalNumber* resDecimal = [[self.decimalContainer decimalNumber] decimalNumberByDividingBy:[bigDecimal decimalNumber]];
    QTUMBigNumber* res = [QTUMBigNumber decimalWithString:resDecimal.stringValue];
    return res;
}

- (instancetype)remainder:(QTUMBigNumber *)bigInteger {
    
    JKBigDecimal* resDecimal = [self.decimalContainer remainder:bigInteger.decimalContainer];
    QTUMBigNumber* res = [QTUMBigNumber decimalWithString:resDecimal.stringValue];
    return res;
}

- (NSComparisonResult) compare:(QTUMBigNumber *)other {
    return [self.decimalContainer compare:other.decimalContainer];
}

- (instancetype)pow:(unsigned int)exponent {
    return [self pow:exponent];
}

- (instancetype)negate {
    return [self.decimalContainer negate];
}

- (instancetype)abs {
    return [self.decimalContainer abs];
}

- (NSString *)stringValue {
    return _stringNumberValue;
}

- (NSString *)description {
    return [self.decimalContainer description];
}

- (BTCAmount)satoshiAmountValue {

    QTUMBigNumber* amountMultiplyNumber = [[QTUMBigNumber alloc] initWithInteger:BTCCoin];
    BTCAmount amount = [self multiply:amountMultiplyNumber].integerValue;
    return amount;
}

- (NSInteger)qtumAmountValue {
    
    QTUMBigNumber* amountMultiplyNumber = [[QTUMBigNumber alloc] initWithInteger:BTCCoin];
    NSInteger amount = [self divide:amountMultiplyNumber].integerValue;
    return amount;
}

#pragma  mark - NSCoder

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.stringNumberValue forKey:@"stringNumberValue"];
    [aCoder encodeObject:self.decimalContainer forKey:@"decimalContainer"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    NSString *stringNumberValue = [aDecoder decodeObjectForKey:@"stringNumberValue"];
    JKBigDecimal *decimalContainer = [aDecoder decodeObjectForKey:@"decimalContainer"];
    
    self = [super init];
    
    if (self) {
        
        _stringNumberValue = stringNumberValue;
        _decimalContainer = decimalContainer;
    }
    
    return self;
}

@end


@implementation QTUMBigNumber (Comparison)

- (BOOL)isLessThan:(QTUMBigNumber *)decimalNumber {
    return [self.decimalContainer compare:decimalNumber.decimalContainer] == NSOrderedAscending;
}

- (BOOL)isLessThanOrEqualTo:(QTUMBigNumber *)decimalNumber {
    return [self.decimalContainer compare:decimalNumber.decimalContainer] != NSOrderedDescending;
}

- (BOOL)isGreaterThan:(QTUMBigNumber *)decimalNumber {
    return [self.decimalContainer compare:decimalNumber.decimalContainer] == NSOrderedDescending;
}

- (BOOL)isGreaterThanOrEqualTo:(QTUMBigNumber *)decimalNumber {
    return [self.decimalContainer compare:decimalNumber.decimalContainer] != NSOrderedAscending;
}

- (BOOL)isEqualToDecimalNumber:(QTUMBigNumber *)decimalNumber {
    
    return [self.decimalContainer compare:decimalNumber.decimalContainer] == NSOrderedSame;
}

- (NSComparisonResult) compareWithInt:(int)i {
    
    return [self.decimalContainer compare:[[JKBigDecimal alloc] initWithString:[NSString stringWithFormat:@"%i", i]]];
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
    
    return [self.decimalContainer decimalNumber];
}

- (NSDecimalNumber*)roundedNumberWithScale:(NSInteger) scale {
    
    return [self.decimalContainer roundedNumberWithScale:scale];
}

@end

@implementation QTUMBigNumber (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(QTUMBigNumber*) power {
    
    BTCMutableBigNumber* btcNumber = [[[BTCMutableBigNumber alloc] initWithDecimalString:power.stringValue] multiply:[BTCBigNumber negativeOne]];
    return [self shortFormatOfNumberWithAddedPower:btcNumber];
}

-(NSString*)shortFormatOfNumberWithPowerOf10:(QTUMBigNumber*) power {
    
    BTCBigNumber* btcNumber = [[BTCBigNumber alloc] initWithDecimalString:power.stringValue];
    return [self shortFormatOfNumberWithAddedPower:[btcNumber copy]];
}

-(QTUMBigNumber*)numberWithPowerOfMinus10:(QTUMBigNumber*) power {
    
    
    JKBigDecimal* bigDecimal = [self.decimalContainer numberWithPowerOfMinus10:power.decimalContainer];
    return [QTUMBigNumber decimalWithString:bigDecimal.stringValue];
}

-(QTUMBigNumber*)numberWithPowerOf10:(QTUMBigNumber*) power {
    
    JKBigDecimal* bigDecimal = [self.decimalContainer numberWithPowerOf10:power.decimalContainer];
    return [QTUMBigNumber decimalWithString:bigDecimal.stringValue];
    
}

-(NSString*)stringNumberWithPowerOfMinus10:(QTUMBigNumber*) power {
    
    NSString* value = self.stringValue;
    NSInteger valueCount = self.decimalContainer.bigInteger.stringValue.length;
    NSInteger reduceDigits = (power.integerValue - 1);
    
    if ([self.stringValue isEqualToString:@"0"]) {
        return  self.stringValue;
    }
    
    if ((reduceDigits - valueCount) > 255) {
        return  @"0.00000000000000000000000000000000000000000E";
    }
    
    NSString* result;
    NSInteger integerDigitsAfter = valueCount - reduceDigits;
    
    if (integerDigitsAfter > 0) {
        
        NSMutableString* temp = [value mutableCopy];
        NSRange pointRange = [temp rangeOfString:@"."];
        
        if (pointRange.location == NSNotFound) {
            pointRange = NSMakeRange(valueCount, 1);
        }
        
        temp = [[temp stringByReplacingOccurrencesOfString:@"." withString:@""] mutableCopy];
        [temp insertString:@"." atIndex:pointRange.location - power.integerValue];
        
        result = [temp copy];
    } else {
        NSString* zeroString = @"0.";
        
        for (int i = 0; i < integerDigitsAfter * -1 + 1; i++) {
            zeroString = [zeroString stringByAppendingString:@"0"];
        }
        
        result = [zeroString stringByAppendingString:[value stringByReplacingOccurrencesOfString:@"." withString:@""]];
    }
    
    return result;
}

-(NSString*)stringNumberWithPowerOf10:(QTUMBigNumber*) power {
    
    
    return [self.decimalContainer stringNumberWithPowerOf10:power.decimalContainer];
}

-(NSString*)shortFormatOfNumber {
    
    BTCBigNumber* btcNumber = [[BTCBigNumber alloc] initWithDecimalString:@"0"];
    return [self shortFormatOfNumberWithAddedPower:btcNumber];
}

-(NSString*)shortFormatOfNumberWithAddedPower:(BTCBigNumber*) power {
    
    NSString* inputString = self.stringValue;

    if ([inputString isEqualToString:@"0"]){
        return inputString;
    }
    
    float value;
    BOOL isNegativeFormat = NO;
    BTCMutableBigNumber* lenght = [[BTCMutableBigNumber alloc] initWithUInt32:0];
        
    //used regex
    NSRegularExpression* twoPartOfDecimal = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:0 error:NULL];
    NSRegularExpression* firstDigitsFromStringWithPoinRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9.]{1,5}" options:0 error:NULL];
    NSRegularExpression* firstFourDigitsFromStringPoinRegex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]{1,4}" options:0 error:NULL];
    NSRegularExpression* decimalValueToFirstNonZeroRegex = [NSRegularExpression regularExpressionWithPattern:@"[^1-9]*[0-9]" options:0 error:NULL];
    NSRegularExpression* intValueFromDecimalPartRegex = [NSRegularExpression regularExpressionWithPattern:@"[0]{0,}([0-9]+)" options:0 error:NULL];

    NSArray<NSTextCheckingResult *> *matches = [twoPartOfDecimal matchesInString:inputString options:0 range:NSMakeRange(0, inputString.length)];
    
    //bail if no matching
    if (matches.count == 0) {
        return @"0";
    }
    
    //geting first 3 digits of decimal maybe with point
    NSString* integerValueString = [inputString substringWithRange:[matches[0] range]];
    NSTextCheckingResult* threeDigitMatch = [firstDigitsFromStringWithPoinRegex firstMatchInString:inputString options:0 range:NSMakeRange(0, inputString.length)];
    NSString* firstDigitsString = [inputString substringWithRange:[threeDigitMatch range]];
    value = [firstDigitsString floatValue];
    
    //checking if first digits of decimal greater then zero
    if (value >= 1) {
        
        lenght = [[[[BTCMutableBigNumber alloc] initWithUInt64:integerValueString.length] subtract:[[BTCBigNumber alloc] initWithInt32:1]] add:power];
        isNegativeFormat = NO;
    }
    
    //decimal less then 1 and we need to parce decimal part
    else {
        
        //getting string to first character (0000555000 => 00005) to determine lengh of exp
        NSString* decimalValueString = [inputString substringWithRange:[matches[1] range]];
        NSTextCheckingResult* decimalToNonZeroRes = [decimalValueToFirstNonZeroRegex firstMatchInString:decimalValueString options:0 range:NSMakeRange(0, decimalValueString.length)];
        NSString* decimalToNonZeroString = [decimalValueString substringWithRange:[decimalToNonZeroRes range]];
        
        //lenght must be negative, coz value less then zero
        lenght = [[[[BTCMutableBigNumber alloc] initWithUInt64:decimalToNonZeroString.length] multiply:[BTCBigNumber negativeOne]] add:power];
        
        //getting int value without zeros at the begining (0000555000 => 555000)
        NSTextCheckingResult* intValueFromDecimalPartRes = [intValueFromDecimalPartRegex firstMatchInString:decimalValueString options:0 range:NSMakeRange(0, decimalValueString.length)];
        NSRange intFomDecimal = [intValueFromDecimalPartRes rangeAtIndex:1];
        
        //getting first 4 digits from int part of decimal part, coz we can get a lot of digits (0000555012312312312300 => 5550)
        NSString *matchString = [decimalValueString substringWithRange:intFomDecimal];
        threeDigitMatch = [firstFourDigitsFromStringPoinRegex firstMatchInString:matchString options:0 range:NSMakeRange(0, matchString.length)];
        firstDigitsString = [matchString substringWithRange:[threeDigitMatch range]];
        
        //getting float from 4 digits
        value = [firstDigitsString floatValue];
    }
    
    isNegativeFormat = [lenght less:[BTCBigNumber zero]];
    
    //getting abs of lenght, its for making right result string
    if (isNegativeFormat) {
        lenght = [lenght multiply:[BTCBigNumber negativeOne]];
    }
    
    while (value >= 10.) {
        value /= 10.;
    }
    
    NSString* stringValue = value > (int16_t)value ?
    [NSString stringWithFormat:@"%.2f", value] :
    [NSString stringWithFormat:@"%i", (int16_t)value];
    
    NSString* result = [NSString stringWithFormat:@"%@E%@%@",stringValue,isNegativeFormat ? @"-" : @"+",lenght.decimalString];
    
    return result;
}

-(QTUMBigNumber*)tenInPower:(QTUMBigNumber* )power {
    
    NSString* string = [power stringValue];
    return [[[JKBigDecimal alloc] initWithString:@"10"] pow:string.intValue];
}

@end

