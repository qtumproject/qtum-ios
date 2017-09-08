//
//  NSString+AbiRegex.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NSString+AbiRegex.h"

@implementation NSString (AbiRegex)

-(BOOL)isUintFromAbi {
    
    NSString *pattern = @"(uint[0-9]{0,3})$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isIntFromAbi {
    
    NSString *pattern = @"(int[0-9]{0,3})$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isBoolFromAbi {
    
    return [self isEqualToString:@"bool"];
}

-(BOOL)isBytesFixedFromAbi {
    
    NSString *pattern = @"(bytes[0-9]{1,3})$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isBytesFromAbi {
    
    NSString *pattern = @"(bytes)$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isArrayFromAbi {
    
    NSString *pattern = @"^([a-zA-Z]\\w+\\[[0-9]{0,}\\])$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isArrayOfArraysFromAbi {
    
    NSString *pattern = @"\\b([a-zA-Z]{1,}.{0,}\\[[1-9]{1,}[0-9]{0,}\\]\\[\\])$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isAddressFromAbi {
    
    return [self isEqualToString:@"address"];
}

-(BOOL)isStringFromAbi {
    
    return [self isEqualToString:@"string"];
}

-(BOOL)isFixedArrayOfStringFromAbi {
    
    return [self isEqualToString:@"string[]"];
}

-(BOOL)isDynamicArrayOfStringFromAbi {

    NSString *pattern = @"(string\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isFixedArrayOfUintFromAbi {
    
    NSString *pattern = @"(uint[0-9]{0,3}\\[[0-9]{1,}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isDynamicArrayOfUintFromAbi {
    
    NSString *pattern = @"(uint[0-9]{0,3}\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isFixedArrayOfIntFromAbi {
    
    NSString *pattern = @"(int[0-9]{0,3}\\[[0-9]{1,}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isDynamicArrayOfIntFromAbi {
    
    NSString *pattern = @"(int[0-9]{0,3}\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isFixedArrayOfBoolFromAbi {
    
    NSString *pattern = @"(bool\\[[0-9]{1,}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isDynamicArrayOfBoolFromAbi {
    
    NSString *pattern = @"(bool\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isFixedArrayOfBytesFromAbi {
    
    return [self isEqualToString:@"bytes[]"];
}

-(BOOL)isDynamicArrayOfBytesFromAbi {
    
    NSString *pattern = @"(bytes\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

- (BOOL)isFixedArrayOfAddressesFromAbi {
    
    return [self isEqualToString:@"address[]"];
}

- (BOOL)isDynamicArrayOfAddressesFromAbi {
    
    NSString *pattern = @"(address\\[[0-9]{0,0}\\]$)";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isFixedArrayOfFixedBytesFromAbi {
    
    NSString *pattern = @"(bytes[0-9]{1,3}\\[[0-9]{1,}])$";
    return [self isMatchStringPattern:pattern];
}

-(BOOL)isDynamicArrayOfFixedBytesFromAbi {
    
    NSString *pattern = @"(bytes[0-9]{1,3}\\[[0-9]{0,0}])$";
    return [self isMatchStringPattern:pattern];
}

- (NSInteger)arraySize {
    
    NSString* pattern = @"([[0-9]{1,}])";
    NSString* match = [self matchedStringWithPattern:pattern];
    return [match integerValue];
}

- (NSArray<NSNumber*>*)arrayOfArraySizes {
    
    NSString* pattern = @"([[0-9]{1,}])";
    NSString* match = [self matchedStringWithPattern:pattern];
//    return [match integerValue];
    return nil;
}

-(NSInteger)fixedBytesSize {
    
    NSString* pattern = @"([0-9]{1,})";
    NSString* match = [self matchedStringWithPattern:pattern];
    return [match integerValue];
}

-(NSInteger)uintSize {
    
    NSString* pattern = @"([0-9]{1,})";
    NSString* match = [self matchedStringWithPattern:pattern];
    
    return [match integerValue] ?: 256;
}

-(NSInteger)intSize {
    
    NSString* pattern = @"([0-9]{1,})";
    NSString* match = [self matchedStringWithPattern:pattern];
    
    return [match integerValue] ?:256;
}

- (BOOL)isMatchStringPattern:(NSString*) pattern {
    
    NSString *expression = pattern;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return numberOfMatches != 0;
}

- (NSString*)matchedStringWithPattern:(NSString*) pattern {
    
    NSString *expression = pattern;
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange range = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    
    if (range.location != NSNotFound) {
        return [self substringWithRange:range];
    } else {
        return nil;
    }
}

- (NSString*)stringFromBracer:(NSString*) stringWithBracer {
    
    return [[stringWithBracer
             stringByReplacingOccurrencesOfString:@"[" withString:@""]
                stringByReplacingOccurrencesOfString:@"]" withString:@""];
}
#pragma mark -

- (NSArray<NSString*>*)dynamicArrayElementsFromParameter {
    
    NSString* paramterWithoutBracer = [self stringFromBracer:self];
    return [paramterWithoutBracer componentsSeparatedByString:@","];
}
  
- (NSArray<NSString*>*)dynamicArrayStringsFromParameter {
  
    NSString* paramterWithoutBracer = [self stringFromBracer:self];
    NSMutableArray <NSString*> *machesArray = @[].mutableCopy;
    NSString *expression = @"\"(\\.|[^\"])*\"";

    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray<NSTextCheckingResult *> *resultsRanges = [regex matchesInString:paramterWithoutBracer options:0 range:NSMakeRange(0, [paramterWithoutBracer length])];
    
    for (NSTextCheckingResult* result in resultsRanges) {
        [machesArray addObject:[paramterWithoutBracer substringWithRange:NSMakeRange(result.range.location + 1, result.range.length - 2)]];
    }
    
    return [machesArray copy];
}



@end
