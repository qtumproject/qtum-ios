//
//  NSData+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData (Extension)

+ (NSData *)reverseData:(NSData *)data {
    const char *bytes = [data bytes];
    int idx = (int)([data length] - 1);
    char *reversedBytes = calloc(sizeof(char),[data length]);
    for (int i = 0; i < [data length]; i++) {
        reversedBytes[idx--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:[data length]];
    free(reversedBytes);
    return reversedData;
}

@end
