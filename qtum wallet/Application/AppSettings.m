//
//  AppSettings.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AppSettings.h"
#import "NSUserDefaults+Settings.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "LanguageManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppSettings ()

@property (assign, nonatomic) BOOL isMainNet;
@property (assign, nonatomic) BOOL isRPC;

@end

@implementation AppSettings

#pragma mark - init

+ (instancetype)sharedInstance
{
    static AppSettings *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    
    if (self != nil) {
    }
    return self;
}

#pragma mark - Private Methods

-(void)setup {
    
    [NSUserDefaults saveIsDarkSchemeSetting:NO];
    [NSUserDefaults saveIsRPCOnSetting:NO];
    [NSUserDefaults saveIsMainnetSetting:YES];
    [PopUpsManager sharedInstance];
    [self setupFabric];
    [self setupFingerpring];
}

-(void)setupFabric{
    [Fabric with:@[[Crashlytics class]]];
}

-(void)setupFingerpring {

    if( SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"9.0") && [[[LAContext alloc] init] canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        [NSUserDefaults saveIsFingerpringAllowed:YES];
    } else {
        [NSUserDefaults saveIsFingerpringAllowed:NO];
    }
}

#pragma mark - Accessory methods

-(BOOL)isMainNet{
    return [NSUserDefaults isMainnetSetting];
}

-(BOOL)isRPC{
    return [NSUserDefaults isRPCOnSetting];
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
