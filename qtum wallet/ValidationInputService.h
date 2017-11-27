//
//  ValidationInputService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ValidationRegexProvider;

@interface ValidationInputService : NSObject

- (instancetype)initWithRegexProvider:(ValidationRegexProvider*) regexProvider;

- (BOOL)isValidSymbols:(NSString*)string forParameter:(id <AbiParameterProtocol>) parameter;
- (BOOL)isValidString:(NSString*)string forParameter:(id <AbiParameterProtocol>) parameter;

- (BOOL)isValidAddressSymbolsInString:(NSString*)string;
- (BOOL)isValidAddressString:(NSString*)string;

- (BOOL)isValidAmountString:(NSString*)string;
- (BOOL)isValidContractAmountString:(NSString*)string;

- (BOOL)isValidContractAddressString:(NSString*)string;
- (BOOL)isValidSymbolsContractAddressString:(NSString*)string;

@end
