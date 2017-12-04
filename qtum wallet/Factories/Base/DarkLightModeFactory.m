//
//  DarkLightModeFactory.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "DarkLightModeFactory.h"
#import "NSUserDefaults+Settings.h"

@implementation DarkLightModeFactory

- (NSString *)identifireDependsOnStyleWithIdentifire:(NSString *) identifire {
    
    NSString* appendString;
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        appendString = @"Dark";
    } else {
        appendString = @"Light";
    }
    
    return [identifire stringByAppendingString:appendString];
}


@end
