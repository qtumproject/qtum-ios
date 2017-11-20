//
//  NSObject+Catch.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSNull+Catch.h"

@implementation NSNull (Catch)


- (NSMethodSignature *)methodSignatureForSelector:(SEL) aSelector {
	NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

	if (!signature) {
		signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
	}

	return signature;
}

- (void)forwardInvocation:(NSInvocation *) anInvocation {
	DLog(@"NULL EXEPTION");
	//[NSException raise:NSInvalidArgumentException format:@"NULL EXEPTION"];
}

- (NSNumber *)roundedNumberWithScale:(NSInteger) scale {
	return [NSNumber new];
}

@end
