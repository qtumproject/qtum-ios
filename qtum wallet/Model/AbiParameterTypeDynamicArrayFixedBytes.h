//
//  AbiParameterTypeDynamicArrayFixedBytes.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiParameterTypeDynamicElementaryArray.h"

@interface AbiParameterTypeDynamicArrayFixedBytes : AbiParameterTypeDynamicElementaryArray

@property (assign, nonatomic) NSInteger elementSize;

- (instancetype)initWithSizeOfElements:(NSUInteger) elementSize;

@end
