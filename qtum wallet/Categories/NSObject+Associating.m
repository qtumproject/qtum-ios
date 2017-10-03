//
//  NSObject+Associating.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSObject+Associating.h"
#import <objc/runtime.h>


@implementation NSObject (Associating)

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
