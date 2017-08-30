//
//  NSString+AbiRegex.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AbiRegex)

- (BOOL)isUintFromAbi;
- (BOOL)isIntFromAbi;
- (BOOL)isBytesFixedFromAbi;
- (BOOL)isBytesFromAbi;
- (BOOL)isArrayFromAbi;
- (BOOL)isArrayOfArraysFromAbi;
- (BOOL)isAddressFromAbi;
- (BOOL)isStringFromAbi;
- (BOOL)isBoolFromAbi;

- (NSInteger)fixedBytesSize;
- (NSInteger)uintSize;
- (NSInteger)intSize;

@end
