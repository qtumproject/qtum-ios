//
//  AbiParameterTypeFixedArray.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AbiParameterTypeArray.h"

@interface AbiParameterTypeFixedArray : AbiParameterTypeArray

- (instancetype)initWithSize:(NSUInteger) size;

@end
