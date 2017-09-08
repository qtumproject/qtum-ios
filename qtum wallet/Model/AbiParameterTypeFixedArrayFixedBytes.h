//
//  AbiParameterTypeFixedArrayFixedBytes.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiParameterTypeFixedElementaryArray.h"

@interface AbiParameterTypeFixedArrayFixedBytes : AbiParameterTypeFixedElementaryArray

@property (assign, nonatomic) NSInteger elementSize;

- (instancetype)initWithSizeOfElements:(NSUInteger) elementSize;

@end
