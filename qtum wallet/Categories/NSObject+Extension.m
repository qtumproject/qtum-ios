//
//  NSObject+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <objc/runtime.h>
#import "Presentable.h"


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

- (UIViewController*)toPresent {
    
    if ([self conformsToProtocol:@protocol(Presentable)] && [self isKindOfClass:[UIViewController class]]) {
        return (UIViewController*)self;
    }
    return nil;
}

@end
