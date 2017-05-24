//
//  NSUserDefaults+Settings.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Settings)

+ (void)saveIsMainnetSetting:(BOOL)value;
+ (BOOL)isMainnetSetting;

+ (void)saveIsRPCOnSetting:(BOOL)value;
+ (BOOL)isRPCOnSetting;

+ (void)saveLanguage:(NSString*)lang;
+ (NSString*)getLanguage;

@end
