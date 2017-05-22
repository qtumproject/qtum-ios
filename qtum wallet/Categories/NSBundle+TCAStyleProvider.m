//
//  NSBundle+TCAStyleProvider.m
//  TCA2016
//
//  Created by Nikita on 09.08.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "NSBundle+TCAStyleProvider.h"

@implementation NSBundle (TCAStyleProvider)

- (NSString *)tca_localizedStringForKey:(NSString *)key class:(Class)tableClass {
    
    NSString *string = [self localizedStringForKey:key value:nil table:NSStringFromClass(tableClass)];
    if ([string isEqualToString:key] == YES && [tableClass superclass] != nil) {
        string = [self tca_localizedStringForKey:key class:[tableClass superclass]];
    }
    return string;
}

@end
