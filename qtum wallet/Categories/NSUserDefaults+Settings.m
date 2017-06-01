//
//  NSUserDefaults+Settings.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NSUserDefaults+Settings.h"

static NSString * const kSettingIsMainnet           = @"kSettingExtraMessages";
static NSString * const kSettingIsRPCOn             = @"kSettingLongMessage";
static NSString * const kLanguageSaveKey            = @"kLanguageSaveKey";


@implementation NSUserDefaults (Settings)

+ (void)saveIsMainnetSetting:(BOOL)value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIsMainnet];
}

+ (BOOL)isMainnetSetting{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsMainnet];
}

+ (void)saveIsRPCOnSetting:(BOOL)value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:kSettingIsRPCOn];
}

+ (BOOL)isRPCOnSetting{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kSettingIsRPCOn];
}

+ (void)saveLanguage:(NSString*)lang{
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:kLanguageSaveKey];
}

+ (NSString*)getLanguage{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLanguageSaveKey];
}

@end
