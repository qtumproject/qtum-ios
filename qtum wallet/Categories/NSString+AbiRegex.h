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
- (BOOL)isAddressFromAbi;
- (BOOL)isStringFromAbi;
- (BOOL)isBoolFromAbi;

- (BOOL)isArrayFromAbi;
- (BOOL)isArrayOfArraysFromAbi;

- (BOOL)isFixedArrayOfStringFromAbi;
- (BOOL)isDynamicArrayOfStringFromAbi;
- (BOOL)isFixedArrayOfUintFromAbi;
- (BOOL)isDynamicArrayOfUintFromAbi;
- (BOOL)isFixedArrayOfIntFromAbi;
- (BOOL)isDynamicArrayOfIntFromAbi;
- (BOOL)isFixedArrayOfBoolFromAbi;
- (BOOL)isDynamicArrayOfBoolFromAbi;
- (BOOL)isFixedArrayOfBytesFromAbi;
- (BOOL)isDynamicArrayOfBytesFromAbi;
- (BOOL)isFixedArrayOfFixedBytesFromAbi;
- (BOOL)isDynamicArrayOfFixedBytesFromAbi;

- (NSInteger)arraySize;
- (NSInteger)fixedBytesSize;
- (NSInteger)uintSize;
- (NSInteger)intSize;

- (NSArray<NSString*>*)dynamicArrayElementsFromParameter:(NSString*) parameter;

@end
