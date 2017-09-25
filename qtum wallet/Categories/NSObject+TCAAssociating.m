//
//  NSObject+TCAAssociating.m
//  TCA2016
//
//  Created by Nikita on 20.08.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSObject+TCAAssociating.h"
#import <objc/runtime.h>


@implementation NSObject (TCAAssociating)

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

-(BOOL)isNull{
    return [self isKindOfClass:[NSNull class]];
}

- (void)setAssociatedObject:(id)associatedObject
{
    objc_setAssociatedObject(self,
                             @selector(associatedObject),
                             associatedObject,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
