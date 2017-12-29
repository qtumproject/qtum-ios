//
//  ValidationRegexService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidationRegexProvider : NSObject

//full validation
- (NSRegularExpression*)addressParameterValidationRegex;
- (NSRegularExpression*)uintParameterValidationRegexWithSize:(NSInteger) size;
- (NSRegularExpression*)intParameterValidationRegexWithSize:(NSInteger) size;
- (NSRegularExpression*)boolParameterValidationRegex;
- (NSRegularExpression*)arrayParameterValidationRegex;
- (NSRegularExpression*)bytesParameterValidationRegex;
- (NSRegularExpression*)unnownParameterValidationRegex;
- (NSRegularExpression*)fixedBytesParameterValidationRegex;

//symbols validation
- (NSRegularExpression*)addressParameterSymbolsValidationRegex;
- (NSRegularExpression*)uintParameterSymbolsValidationRegexWithSize:(NSInteger) size;
- (NSRegularExpression*)intParameterSymbolsValidationRegexWithSize:(NSInteger) size;
- (NSRegularExpression*)boolParameterSymbolsValidationRegex;
- (NSRegularExpression*)arrayParameterSymbolsValidationRegex;
- (NSRegularExpression*)bytesParameterSymbolsValidationRegex;
- (NSRegularExpression*)unnownParameterSymbolsValidationRegex;
- (NSRegularExpression*)fixedBytesParameterSymbolsValidationRegex;

- (NSRegularExpression*)amountSymbolValidationRegex;
- (NSRegularExpression*)contractAmountSymbolValidationRegex;
- (NSRegularExpression*)contractAddressValidationRegex;
- (NSRegularExpression*)contractAddressSymbolsValidationRegex;


@end
