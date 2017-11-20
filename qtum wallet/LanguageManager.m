//
//  LanguageManager.m
//  ios_language_manager
//
//  Created by Maxim Bilan on 12/23/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "NSBundle+Language.h"
#import "NSUserDefaults+Settings.h"

static NSString * const LanguageCodes[] = { @"en", @"zh-Hant" };
static NSString * const LanguageStrings[] = { @"English", @"Chinese" };
static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LanguageManager

+ (void)setupCurrentLanguage {
    
    NSString *currentLanguage = [NSUserDefaults getLanguage];
    if (!currentLanguage) {
        currentLanguage = LanguageCodes[0];
        [NSUserDefaults saveLanguage:currentLanguage];
    }	

    [[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [NSBundle setLanguage:currentLanguage];
}

+ (NSArray *)languageStrings
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        [array addObject:NSLocalizedString(LanguageStrings[i], @"")];
    }
    return [array copy];
}

+ (NSString *)currentLanguageString
{
    NSString *string = @"";
    NSString *currentCode = [NSUserDefaults getLanguage];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode isEqualToString:LanguageCodes[i]]) {
            string = NSLocalizedString(LanguageStrings[i], @"");
            break;
        }
    }
    return string;
}

+ (NSString *)currentLanguageCode
{
    return [NSUserDefaults getLanguage];
}

+ (NSInteger)currentLanguageIndex
{
    NSInteger index = 0;
    NSString *currentCode = [NSUserDefaults getLanguage];
    for (NSInteger i = 0; i < ELanguageCount; ++i) {
        if ([currentCode containsString:LanguageCodes[i]]) {
            index = i;
            break;
        }
    }
    return index;
}

+ (void)saveLanguageByIndex:(NSInteger)index
{
    if (index >= 0 && index < ELanguageCount) {
        NSString *code = LanguageCodes[index];
        [NSUserDefaults saveLanguage:code];

        [NSBundle setLanguage:code];
    }
}



@end
