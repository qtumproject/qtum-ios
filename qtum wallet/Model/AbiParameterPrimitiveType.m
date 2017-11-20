//
//  AbiParameterPrimitiveType.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation AbiParameterPrimitiveType

- (instancetype)initWithSize:(NSUInteger) size {

	self = [super init];
	if (self) {
		_size = size;
	}
	return self;
}

- (NSInteger)maxValue {

	return powl (2, self.size);
}

- (NSInteger)maxValueLenght {

	return 78;
}

@end
