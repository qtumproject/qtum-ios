//
//  NSObject+StyleProvider.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Localize(key) \
[[NSBundle mainBundle] tca_localizedStringForKey:(key) class:[self class]]

@interface NSBundle (StyleProvider)

- (NSString *)tca_localizedStringForKey:(NSString *) key class:(Class) tableClass;

@end
