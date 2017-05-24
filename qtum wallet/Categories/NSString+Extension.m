//
//  NSString+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

+(NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    string = [string lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = (int)string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

//
+ (NSString *)hexadecimalString:(NSData *)data {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

+ (NSString *)invertHex:(NSString *)hexString{
    
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [hexString length];
    
    while (hexString && charIndex > 0) {
        charIndex -= 2;
        NSRange subStrRange = NSMakeRange(charIndex, 2);
        NSString *substring = [hexString substringWithRange:subStrRange];
        [reversedString appendString:[substring substringWithRange:NSMakeRange(0, 1)]];
        [reversedString appendString:[substring substringWithRange:NSMakeRange(1, 1)]];
    }
    
    return reversedString;
}

+ (NSString*)stringFromCamelCase:(NSString*) camelString {
    
    NSMutableString *newStr = [NSMutableString string];
    
    for (NSInteger i=0; i<camelString.length; i++){
        NSString *ch = [camelString substringWithRange:NSMakeRange(i, 1)];
        if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound) {
            [newStr appendString:@" "];
        }
        [newStr appendString:ch];
    }
    NSLog(@"%@", newStr.capitalizedString);
    return newStr.capitalizedString;
}

@end
