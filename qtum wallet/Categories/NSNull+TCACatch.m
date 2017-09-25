//
//  NSNull+TCACatch.m
//  TCA2016
//
//  Created by Nikita on 09.09.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSNull+TCACatch.h"

@implementation NSNull (TCACatch)


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

    if (!signature) {
        signature = [NSMethodSignature signatureWithObjCTypes:"@:"];
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    DLog(@"NULL EXEPTION");
    //[NSException raise:NSInvalidArgumentException format:@"NULL EXEPTION"];
}

- (NSNumber*)roundedNumberWithScale:(NSInteger) scale {
    return [NSNumber new];
}

@end
