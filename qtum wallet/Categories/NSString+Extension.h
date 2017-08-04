//
//  NSString+Extension.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

+ (NSString *)valueForKey:(NSString *)key fromQueryItems:(NSArray *)queryItems;
+ (NSData *)dataFromHexString:(NSString *)string;
+ (NSString *)hexadecimalString:(NSData *)data;
+ (NSString *)invertHex:(NSString *)hexString;
+ (NSString *)stringFromCamelCase:(NSString*) camelString;
+ (NSString *)randomStringWithLength: (int) len;
- (NSDate*)date;
- (BOOL)isDecimalString;

@end
