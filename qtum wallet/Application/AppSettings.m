//
//  AppSettings.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AppSettings.h"
#import "NSUserDefaults+Settings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LanguageManager.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchIDService.h"

@interface AppSettings ()

@property (assign, nonatomic) BOOL isMainNet;
@property (assign, nonatomic) BOOL isRPC;
@property (assign, nonatomic) BOOL isDarkTheme;

@end

@implementation AppSettings

#pragma mark - init

+ (instancetype)sharedInstance {
    
    static AppSettings *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    return self;
}

#pragma mark - Public Methods

-(void)setup {
    
    if (![NSUserDefaults isNotFirstTimeLaunch]) {

        [NSUserDefaults saveIsDarkSchemeSetting:YES];
        [NSUserDefaults saveIsNotFirstTimeLaunch:YES];
    }
    
    [NSUserDefaults saveCurrentVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
    [NSUserDefaults saveIsRPCOnSetting:NO];
    [NSUserDefaults saveIsMainnetSetting:NO];

    [PopUpsManager sharedInstance];
    [self setupFabric];
    [self setupFingerpring];
}

-(void)setupFabric{
    [Fabric with:@[[Crashlytics class]]];
}

-(void)setupFingerpring {
    
    if( [[TouchIDService sharedInstance] hasTouchId]) {
        [NSUserDefaults saveIsFingerpringAllowed:YES];
    } else {
        [NSUserDefaults saveIsFingerpringAllowed:NO];
    }
}

-(void)changeThemeToDark:(BOOL) needDarkTheme {
    [NSUserDefaults saveIsDarkSchemeSetting:needDarkTheme];
}


#pragma mark - Accessory methods

-(BOOL)isMainNet{
    return [NSUserDefaults isMainnetSetting];
}

-(BOOL)isRPC{
    return [NSUserDefaults isRPCOnSetting];
}

-(BOOL)isDarkTheme{
    return [NSUserDefaults isDarkSchemeSetting];
}

-(BOOL)isFingerprintEnabled{
    return [NSUserDefaults isFingerprintAllowed] && [NSUserDefaults isFingerprintEnabled];
}

-(BOOL)isFingerprintAllowed{
    return [NSUserDefaults isFingerprintAllowed];
}

#pragma mark - Private Methods 

-(void)setFingerprintEnabled:(BOOL)enabled {
    [NSUserDefaults saveIsFingerpringEnabled:enabled];
}

@end
