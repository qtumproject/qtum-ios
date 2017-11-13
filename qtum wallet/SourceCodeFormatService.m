//
//  SourceCodeFormatService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SourceCodeFormatService.h"

@implementation SourceCodeFormatService

-(NSAttributedString*)formattingSourceCodeStringWithString:(NSString*) sourceCode {
    
    //formating all font
    NSMutableAttributedString* formattedString = [[NSMutableAttributedString alloc] initWithString:sourceCode];
    UIFont* fontOfCode = [UIFont systemFontOfSize:11];
    UIColor* colorOfCode = [UIColor redColor];
    [formattedString addAttribute:NSFontAttributeName value:fontOfCode range:NSMakeRange(0, sourceCode.length)];
    [formattedString addAttribute:NSForegroundColorAttributeName value:colorOfCode range:NSMakeRange(0, sourceCode.length)];
    
    //Solidity color
    NSRegularExpression* pragmaSoliditysRegex = [NSRegularExpression regularExpressionWithPattern:@"pragma[[:space:]]+solidity[[:space:]]+(\\^[0-9.]+)" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *matches = [pragmaSoliditysRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
    
    UIColor* pragmaSolidityColor = [UIColor blueColor];
    
    for (NSTextCheckingResult* match in matches) {
        
        NSRange rengeOfSolidityNumber = [match rangeAtIndex:0];
        [formattedString addAttribute:NSForegroundColorAttributeName value:pragmaSolidityColor range:rengeOfSolidityNumber];
    }
    
    //decimals color
    NSRegularExpression* dicimalsRegex = [NSRegularExpression regularExpressionWithPattern:@"[-+]?\\b\\d+\\b" options:0 error:NULL];
    matches = [dicimalsRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
    
    UIColor* numberColor = [UIColor blueColor];

    for (NSTextCheckingResult* match in matches) {
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:numberColor range:match.range];
    }
    
    //
    NSRegularExpression* reservedWordsorKeywordsRegex = [NSRegularExpression regularExpressionWithPattern:@"\\b(uint[0-9]{0,3}|bool|int[0-9]{0,3}|address|string)\\b" options:0 error:NULL];
    matches = [reservedWordsorKeywordsRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
    
    UIColor* speciamWordsColor = [UIColor yellowColor];
    
    for (NSTextCheckingResult* match in matches) {
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:speciamWordsColor range:match.range];
    }
    
    NSRegularExpression* functionRegex = [NSRegularExpression regularExpressionWithPattern:@"(function)[[:space:]]+(\\w+)(\\(([^)]*)\\))" options:0 error:NULL];
    matches = [functionRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
    
    UIColor* funcWordColor = [UIColor brownColor];
    UIColor* paramColor = [UIColor grayColor];
    UIColor* funcNameColor = [UIColor lightGrayColor];

    for (NSTextCheckingResult* match in matches) {
        
        NSRange rangeOfFuncWord = [match rangeAtIndex:0];
        NSRange rangeOfFuncName = [match rangeAtIndex:1];
        NSRange rangeOfParam = [match rangeAtIndex:3];
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:funcWordColor range:rangeOfFuncWord];
        [formattedString addAttribute:NSForegroundColorAttributeName value:funcNameColor range:rangeOfFuncName];
        [formattedString addAttribute:NSForegroundColorAttributeName value:paramColor range:rangeOfParam];
    }
    
    NSRegularExpression* commentsRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\/\\*([^*]|[\\r\\n]|(\\*+([^*\\/]|[\\r\\n])))*\\*+\\/)|(\\/\\/.*)" options:0 error:NULL];
    
    matches = [commentsRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
    
    UIColor* commentsColor = [UIColor greenColor];
    
    for (NSTextCheckingResult* match in matches) {

        [formattedString addAttribute:NSForegroundColorAttributeName value:commentsColor range:match.range];
    }
    
    return formattedString;
}

@end
