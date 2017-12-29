//
//  ValidationRegexService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ValidationRegexProvider.h"

@implementation ValidationRegexProvider

- (NSRegularExpression*)addressParameterSymbolsValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^[qQ][a-km-zA-HJ-NP-Z1-9]{0,33}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)uintParameterSymbolsValidationRegexWithSize:(NSInteger) size {
    
    NSString* pattern = [NSString stringWithFormat:@"(^[0]{0,1}$|^[1-9]{1}[0-9]{0,}$)"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)intParameterSymbolsValidationRegexWithSize:(NSInteger) size {
    
    NSString* pattern = [NSString stringWithFormat:@"(^[0]{0,1}$|^[1-9]{1}[0-9]{0,}$)"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)boolParameterSymbolsValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^\\d{0,1}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)arrayParameterSymbolsValidationRegex {
    return nil;
}

- (NSRegularExpression*)bytesParameterSymbolsValidationRegex {
    return nil;
}

- (NSRegularExpression*)unnownParameterSymbolsValidationRegex {
    return nil;
}

- (NSRegularExpression*)fixedBytesParameterSymbolsValidationRegex {
    return nil;
}

- (NSRegularExpression*)addressParameterValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^[qQ][a-km-zA-HJ-NP-Z1-9]{24,33}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)uintParameterValidationRegexWithSize:(NSInteger) size {
    
    NSString* pattern = [NSString stringWithFormat:@"(^[0]{1}$|^[1-9]{1}[0-9]{0,}$)"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)intParameterValidationRegexWithSize:(NSInteger) size {
    
    NSString* pattern = [NSString stringWithFormat:@"(^[0]{1}$|^[1-9]{1}[0-9]{0,}$)"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)boolParameterValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^\\d{1}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)arrayParameterValidationRegex {
    return nil;
}

- (NSRegularExpression*)bytesParameterValidationRegex {
    return nil;
}

- (NSRegularExpression*)unnownParameterValidationRegex {
    return nil;
}

- (NSRegularExpression*)fixedBytesParameterValidationRegex {
    return nil;
}


#pragma mark Amount

- (NSRegularExpression*)amountSymbolValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^\\d+[.,]{0,1}\\d{0,8}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)contractAmountSymbolValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^[^.,]\\d*[.,]{0,1}\\d*$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)contractAddressValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^[1-9A-Za-z][^OIl]{39}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

- (NSRegularExpression*)contractAddressSymbolsValidationRegex {
    
    NSString* pattern = [NSString stringWithFormat:@"^[1-9A-Za-z][^OIl]{0,39}$"];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAnchorsMatchLines error:NULL];
    return regex;
}

@end
