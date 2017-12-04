//
//  AbiParameterTypeDynamicArrayFixedBytes.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation AbiParameterTypeDynamicArrayFixedBytes

- (instancetype)initWithSizeOfElements:(NSUInteger) elementSize {

	self = [super init];
	if (self) {

		_elementSize = elementSize;
	}
	return self;
}

@end
