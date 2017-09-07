//
//  AbiParameterTypeFixedArray.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiParameterTypeArray.h"

@interface AbiParameterTypeFixedArray : AbiParameterTypeArray

@property (assign, nonatomic) NSInteger size;

- (instancetype)initWithSize:(NSUInteger) size;

@end
