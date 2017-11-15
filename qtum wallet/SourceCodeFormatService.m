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
    
    NSString* newSourceCode = [self removeSpacesAfterNewLine:sourceCode];
    
    
    //formating all font
    NSMutableAttributedString* formattedString = [[NSMutableAttributedString alloc] initWithString:newSourceCode];
    UIFont* fontOfCode = [UIFont fontWithName:@"simplonmono-regular" size:11];
    UIColor* colorOfCode = [UIColor colorWithRed:197/255. green:197/255. blue:197/255. alpha:1];
    [formattedString addAttribute:NSFontAttributeName value:fontOfCode range:NSMakeRange(0, newSourceCode.length)];
    [formattedString addAttribute:NSForegroundColorAttributeName value:colorOfCode range:NSMakeRange(0, newSourceCode.length)];
    
    formattedString = [self stringWithParagraphStyle:formattedString andThreeOfFunc:[self recourciveSearchInDepthWithText:newSourceCode]];
    
    //Solidity color
    NSRegularExpression* pragmaSoliditysRegex = [NSRegularExpression regularExpressionWithPattern:@"pragma[[:space:]]+solidity[[:space:]]+(\\^[0-9.]+)" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *matches = [pragmaSoliditysRegex matchesInString:newSourceCode options:0 range:NSMakeRange(0, newSourceCode.length)];
    
    UIColor* pragmaSolidityColor = [UIColor colorWithRed:0/255. green:150/255. blue:255/255. alpha:1];
    
    for (NSTextCheckingResult* match in matches) {
        
        NSRange rengeOfSolidityNumber = [match rangeAtIndex:0];
        [formattedString addAttribute:NSForegroundColorAttributeName value:pragmaSolidityColor range:rengeOfSolidityNumber];
    }
    
    //decimals color
    NSRegularExpression* dicimalsRegex = [NSRegularExpression regularExpressionWithPattern:@"[-+]?\\b\\d+\\b" options:0 error:NULL];
    matches = [dicimalsRegex matchesInString:newSourceCode options:0 range:NSMakeRange(0, newSourceCode.length)];
    
    UIColor* numberColor = [UIColor colorWithRed:0/255. green:150/255. blue:255/255. alpha:1];

    for (NSTextCheckingResult* match in matches) {
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:numberColor range:match.range];
    }
    
    //
    NSRegularExpression* reservedWordsorKeywordsRegex = [NSRegularExpression regularExpressionWithPattern:@"\\b(uint[0-9]{0,3}|bool|int[0-9]{0,3}|address|string|struct|public)\\b" options:0 error:NULL];
    matches = [reservedWordsorKeywordsRegex matchesInString:newSourceCode options:0 range:NSMakeRange(0, newSourceCode.length)];
    
    UIColor* speciamWordsColor = [UIColor colorWithRed:229/255. green:247/255. blue:131/255. alpha:1];
    
    for (NSTextCheckingResult* match in matches) {
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:speciamWordsColor range:match.range];
    }
    
    NSRegularExpression* functionRegex = [NSRegularExpression regularExpressionWithPattern:@"(function)[[:space:]]+(\\w+)(\\(([^)]*)\\))" options:0 error:NULL];
    matches = [functionRegex matchesInString:newSourceCode options:0 range:NSMakeRange(0, newSourceCode.length)];
    
    UIColor* funcWordColor =  [UIColor colorWithRed:0/255. green:150/255. blue:255/255. alpha:1];
    UIColor* paramColor =  [UIColor colorWithRed:229/255. green:247/255. blue:131/255. alpha:1];
    UIColor* funcNameColor =  [UIColor colorWithRed:0/255. green:150/255. blue:255/255. alpha:1];

    for (NSTextCheckingResult* match in matches) {
        
        NSRange rangeOfFuncWord = [match rangeAtIndex:0];
        NSRange rangeOfFuncName = [match rangeAtIndex:1];
        NSRange rangeOfParam = [match rangeAtIndex:3];
        
        [formattedString addAttribute:NSForegroundColorAttributeName value:funcWordColor range:rangeOfFuncWord];
        [formattedString addAttribute:NSForegroundColorAttributeName value:funcNameColor range:rangeOfFuncName];
        [formattedString addAttribute:NSForegroundColorAttributeName value:paramColor range:rangeOfParam];
    }
    
    NSRegularExpression* commentsRegex = [NSRegularExpression regularExpressionWithPattern:@"(\\/\\*([^*]|[\\r\\n]|(\\*+([^*\\/]|[\\r\\n])))*\\*+\\/)|(\\/\\/.*)" options:0 error:NULL];
    
    matches = [commentsRegex matchesInString:newSourceCode options:0 range:NSMakeRange(0, newSourceCode.length)];
    
    UIColor* commentsColor = [UIColor colorWithRed:138/255. green:202/255. blue:128/255. alpha:1];
    
    for (NSTextCheckingResult* match in matches) {

        [formattedString addAttribute:NSForegroundColorAttributeName value:commentsColor range:match.range];
    }
    
    return formattedString;
}

-(NSString*)removeSpacesAfterNewLine:(NSString*) sourceCode {
    
    NSRegularExpression* spacesesAfterNewLineRegex = [NSRegularExpression regularExpressionWithPattern:@"\\n[[:space:]]+" options:0 error:NULL];
    return [spacesesAfterNewLineRegex stringByReplacingMatchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length) withTemplate:@"\n"];
}

-(NSMutableAttributedString*)stringWithParagraphStyle:(NSMutableAttributedString*) sourceCode andThreeOfFunc:(NSMutableDictionary <NSNumber*, NSMutableSet*>*) threeOfFunction{
 
    for (NSNumber* key in threeOfFunction) {
        
        NSSet* set = threeOfFunction[key];
        
        for (NSValue* range in set) {
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.headIndent = 20.0 * ([key integerValue] + 1);
            paragraphStyle.firstLineHeadIndent = 20 * ([key integerValue] + 1);
            paragraphStyle.tailIndent = -20.0;
            [sourceCode addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range.rangeValue];
        }
    }
    
    return sourceCode;
}

- (NSMutableDictionary <NSNumber*, NSMutableSet*>*)recourciveSearchInDepthWithText:(NSString*) text {
    
    NSUInteger len = text.length;
    unichar buffer[len + 1];
    [text getCharacters:buffer range:NSMakeRange(0, len)];
    
    NSMutableArray* openningBracersPositions = @[].mutableCopy;
    NSMutableDictionary <NSNumber*, NSMutableSet*>* threeOfFunctionDict = @{}.mutableCopy;


    NSInteger closureBracersCount = 0;
//    NSUInteger location = NSNotFound;
    
    for (NSUInteger i = 0; i < len; i++) {
        
        if (buffer[i] == '{') {
            
            [openningBracersPositions addObject:@(i)];
        } else if (buffer[i] == '}') {
            
            closureBracersCount++;
            NSInteger openingBracerIndex = openningBracersPositions.count - closureBracersCount;
            
            if (openingBracerIndex < openningBracersPositions.count - 1 || openingBracerIndex >= 0) {
                
                NSUInteger location = [openningBracersPositions[openingBracerIndex] unsignedIntegerValue];
                
                NSMutableSet* set = [threeOfFunctionDict objectForKey:@(openingBracerIndex)];
                
                if (!set) {
                    set = [NSMutableSet new];
                    [threeOfFunctionDict setObject:set forKey:@(openingBracerIndex)];
                }
                
                [set addObject:[NSValue valueWithRange:NSMakeRange(location, i - location)]];
                
                closureBracersCount--;
                [openningBracersPositions removeObjectAtIndex:openingBracerIndex];
            }
        }
    }
    
    return threeOfFunctionDict;
}

-(void)buildThreeOfMethodsWithCode:(NSString*) sourceCode {
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.headIndent = 20.0;
//    paragraphStyle.firstLineHeadIndent = 20.0;
//    paragraphStyle.tailIndent = -20.0;
//
//    NSDictionary *attrsDictionary = @{NSFontAttributeName: [UIFont fontWithName:@"TrebuchetMS" size:12.0], NSParagraphStyleAttributeName: paragraphStyle};
//    textView.attributedText = [[NSAttributedString alloc] initWithString:myText attributes:attrsDictionary];
//
//    NSRegularExpression* functionRegex = [NSRegularExpression regularExpressionWithPattern:@"\\n*(.*)({([.]+|[\\r\\n])})" options:0 error:NULL];
//    NSArray<NSTextCheckingResult *> *matches = [functionRegex matchesInString:sourceCode options:0 range:NSMakeRange(0, sourceCode.length)];
//
//    for (NSTextCheckingResult* match in matches) {
//
//        NSLog(@"%@", [sourceCode substringWithRange:match.range]);
//    }
}

@end
