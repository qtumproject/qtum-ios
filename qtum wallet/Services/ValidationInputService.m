//
//  ValidationInputService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ValidationInputService.h"
#import "ValidationRegexProvider.h"

@interface ValidationInputService()

@property (strong, nonatomic) ValidationRegexProvider* regexProvider;

@end

@implementation ValidationInputService

#pragma mark - Init

- (instancetype)initWithRegexProvider:(ValidationRegexProvider*) regexProvider{
    
    self = [super init];
    if (self) {
        _regexProvider = regexProvider;
    }
    return self;
}

#pragma mark - Public Methods

-(BOOL)isValidSymbols:(NSString*)string forParameter:(id <AbiParameterProtocol>) parameter {

    return [self isValidString:string dependsOnParameterType:parameter checkCompleteValidation:NO];
}

-(BOOL)isValidString:(NSString*)string forParameter:(id <AbiParameterProtocol>) parameter {

    return [self isValidString:string dependsOnParameterType:parameter checkCompleteValidation:YES];
}

- (BOOL)isValidAddressSymbolsInString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider addressParameterSymbolsValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidAddressString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider addressParameterValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidAmountString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider amountSymbolValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    QTUMBigNumber* result = [[QTUMBigNumber decimalWithString:string] multiply:[QTUMBigNumber decimalWithInteger:BTCCoin]];
    BOOL comparing = ![result isGreaterThan:[QTUMBigNumber maxBigNumberWithPowerOfTwo:64 isUnsigned:NO]];
    return match && comparing;
}

- (BOOL)isValidContractAmountString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider contractAmountSymbolValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidContractAddressString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider contractAddressValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidSymbolsContractAddressString:(NSString*)string {
    
    NSRegularExpression* regex = [self.regexProvider contractAddressSymbolsValidationRegex];
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}


#pragma mark - Regexes

-(NSRegularExpression*)symbolsValidationRegexDependsOnParameter:(id <AbiParameterProtocol>) parameter {
    
    NSRegularExpression* regex;
    switch (parameter.type) {
            
        case Bytes:
            regex = [self.regexProvider bytesParameterSymbolsValidationRegexWithSize:parameter.size];
            break;
            
        case Unknown:
            regex = [self.regexProvider unnownParameterSymbolsValidationRegex];
            break;
            
        case Uint:
            regex = [self.regexProvider uintParameterSymbolsValidationRegexWithSize:parameter.size];
            break;
            
        case Int:
            regex = [self.regexProvider intParameterSymbolsValidationRegexWithSize:parameter.size];
            break;
            
        case Bool:
            regex = [self.regexProvider boolParameterSymbolsValidationRegex];
            break;
            
        case FixedBytes:
            regex = [self.regexProvider fixedBytesParameterSymbolsValidationRegex];
            break;
            
        case Address:
            regex = [self.regexProvider addressParameterSymbolsValidationRegex];
            break;
        case Array:
            regex = [self.regexProvider arrayParameterSymbolsValidationRegex];
            break;
            
        default:
            regex = [self.regexProvider unnownParameterSymbolsValidationRegex];
            break;
    }
    
    return regex;
}

-(NSRegularExpression*)fullValidationRegexDependsOnParameter:(id <AbiParameterProtocol>) parameter {
    
    NSRegularExpression* regex;
    switch (parameter.type) {
            
        case Bytes:
            regex = [self.regexProvider bytesParameterValidationRegexWithSize:parameter.size];
            break;
            
        case Unknown:
            regex = [self.regexProvider unnownParameterValidationRegex];
            break;
            
        case Uint:
            regex = [self.regexProvider uintParameterValidationRegexWithSize:parameter.size];
            break;
            
        case Int:
            regex = [self.regexProvider intParameterValidationRegexWithSize:parameter.size];
            break;
            
        case Bool:
            regex = [self.regexProvider boolParameterValidationRegex];
            break;
            
        case FixedBytes:
            regex = [self.regexProvider fixedBytesParameterValidationRegex];
            break;
            
        case Address:
            regex = [self.regexProvider addressParameterValidationRegex];
            break;
        case Array:
            regex = [self.regexProvider arrayParameterValidationRegex];
            break;
            
        default:
            regex = [self.regexProvider unnownParameterValidationRegex];
            break;
    }
    
    return regex;
}

-(BOOL)isValidString:(NSString*) string dependsOnParameterType:(id <AbiParameterProtocol>) parameter checkCompleteValidation:(BOOL) complete {
    
    BOOL isValid;
    NSRegularExpression* regex = complete ? [self fullValidationRegexDependsOnParameter:parameter] : [self symbolsValidationRegexDependsOnParameter:parameter];

    switch (parameter.type) {
            
        case Bytes:
            isValid = [self isValidBytesFromString:string withSize:parameter.size withRegex:regex];
            break;

        case Unknown:
            isValid = [self isValidUnnownFromString:string withRegex:regex];
            break;

        case Uint:
            isValid = [self isValidUIntFromString:string withSize:parameter.size withRegex:regex];
            break;

        case Int:
            isValid = [self isValidIntFromString:string withSize:parameter.size withRegex:regex];
            break;

        case Bool:
            isValid = [self isValidBoolFromString:string withRegex:regex];
            break;

        case FixedBytes:
            isValid = [self isValidFixedBytesFromString:string withSize:parameter.size withRegex:regex];
            break;

        case Address:
            isValid = [self isValidAddressFromString:string withRegex:regex];
            break;
        case Array:
            isValid = [self isValidArrayFromString:string withSize:parameter.size withRegex:regex];
            break;
            
        default:
            isValid = [self isValidUnnownFromString:string withRegex:regex];
            break;
    }
    
    return isValid;
}

- (BOOL)isValidUIntFromString:(NSString*) string withSize:(NSInteger) size withRegex:(NSRegularExpression*) regex {
    
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    BOOL comparing = ![[QTUMBigNumber decimalWithString:string] isGreaterThan:[QTUMBigNumber maxBigNumberWithPowerOfTwo:size isUnsigned:YES]];
    return match && comparing;
}

- (BOOL)isValidBytesFromString:(NSString*) string withSize:(NSInteger) size withRegex:(NSRegularExpression*) regex {
    
    BOOL isValid = NO;
    if (string.length > 0) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidUnnownFromString:(NSString*) string withRegex:(NSRegularExpression*) regex {
    return YES;
}

- (BOOL)isValidIntFromString:(NSString*) string withSize:(NSInteger) size withRegex:(NSRegularExpression*) regex {
    
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    BOOL comparing = ![[QTUMBigNumber decimalWithString:string] isGreaterThan:[QTUMBigNumber maxBigNumberWithPowerOfTwo:size isUnsigned:NO]];
    return match && comparing;
}

- (BOOL)isValidBoolFromString:(NSString*) string  withRegex:(NSRegularExpression*) regex {
    
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidFixedBytesFromString:(NSString*) string withSize:(NSInteger) size withRegex:(NSRegularExpression*) regex {
    
    BOOL isValid = NO;
    if (string.length > 0) {
        isValid = YES;
    }
    return isValid;
}

- (BOOL)isValidAddressFromString:(NSString*) string withRegex:(NSRegularExpression*) regex {
    
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:string options:0 range:NSMakeRange (0, string.length)];
    BOOL match = matches.count > 0;
    return match;
}

- (BOOL)isValidArrayFromString:(NSString*) string withSize:(NSInteger) size withRegex:(NSRegularExpression*) regex {
    
    BOOL isValid = NO;
    if (string.length > 0) {
        isValid = YES;
    }
    return isValid;
}

@end
