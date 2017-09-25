//
//  NSUserDefaults+Settings.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Settings)

+ (void)saveIsMainnetSetting:(BOOL)value;
+ (BOOL)isMainnetSetting;

+ (void)saveIsRPCOnSetting:(BOOL)value;
+ (BOOL)isRPCOnSetting;

+ (void)saveLanguage:(NSString*)lang;
+ (NSString*)getLanguage;

+ (void)saveIsFingerpringAllowed:(BOOL)value;
+ (BOOL)isFingerprintAllowed;

+ (void)saveIsFingerpringEnabled:(BOOL)value;
+ (BOOL)isFingerprintEnabled;

+ (void)saveDeviceToken:(NSString*) token;
+ (NSString*)getDeviceToken;

+ (void)savePrevDeviceToken:(NSString*) token;
+ (NSString*)getPrevDeviceToken;

+ (void)saveWalletAddressKey:(NSString*) key;
+ (NSString*)getWalletAddressKey;

+ (void)saveIsHaveWalletKey:(NSString*) key;
+ (NSString*)isHaveWalletKey;

+ (void)saveIsDarkSchemeSetting:(BOOL)value;
+ (BOOL)isDarkSchemeSetting;

+ (void)saveIsNotFirstTimeLaunch:(BOOL)value;
+ (BOOL)isNotFirstTimeLaunch;

+ (void)saveCurrentVersion:(NSString*) value;
+ (NSString*)currentVersion;

@end
