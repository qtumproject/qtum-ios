//
//  NSData+Extension.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extension)

+ (NSData *) reverseData:(NSData *)data;
+ (NSData *) dataWithValue:(NSValue*)value;

@end
