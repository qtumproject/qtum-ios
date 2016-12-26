//
//  NSObject+Extension.m
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

-(NSString*)nameOfClass{
    return NSStringFromClass([self class]);
}

@end
