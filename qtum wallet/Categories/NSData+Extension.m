//
//  NSData+Extension.m
//  qtum wallet
//
//  Created by Никита Федоренко on 18.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NSData+Extension.h"

@implementation NSData (Extension)

+ (NSData *)reverseData:(NSData *)data {
    const char *bytes = [data bytes];
    int idx = [data length] - 1;
    char *reversedBytes = calloc(sizeof(char),[data length]);
    for (int i = 0; i < [data length]; i++) {
        reversedBytes[idx--] = bytes[i];
    }
    NSData *reversedData = [NSData dataWithBytes:reversedBytes length:[data length]];
    free(reversedBytes);
    return reversedData;
}

@end
