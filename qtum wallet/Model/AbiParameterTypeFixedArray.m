//
//  AbiParameterTypeFixedArray.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation AbiParameterTypeFixedArray

- (instancetype)initWithSize:(NSUInteger) size {
    
    self = [super init];
    if (self) {
        _size = size;
    }
    return self;
}

@end
