//
//  NSBundle+TCAStyleProvider.h
//  TCA2016
//
//  Created by Nikita on 09.08.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Localize(key) \
[[NSBundle mainBundle] tca_localizedStringForKey:(key) class:[self class]]

@interface NSBundle (TCAStyleProvider)

- (NSString *)tca_localizedStringForKey:(NSString *)key class:(Class)tableClass;

@end
