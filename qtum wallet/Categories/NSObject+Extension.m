//
//  NSObject+Extension.m
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>


@implementation NSObject (Extension)

-(NSString*)nameOfClass{
    return NSStringFromClass([self class]);
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

- (id)associatedObject
{
    return objc_getAssociatedObject(self, @selector(associatedObject));
}

@end
