//
//  ProfileCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ProfileCoordinator.h"
#import "ProfileOutput.h"
#import "LanguageCoordinator.h"
#import "SubscribeTokenCoordinator.h"
#import "ContractCoordinator.h"

@interface ProfileCoordinator() <ProfileOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, weak) NSObject<ProfileOutput> *profileViewController;

@property (nonatomic, strong) LanguageCoordinator* languageCoordinator;
@property (strong, nonatomic) SubscribeTokenCoordinator* subscribeCoordinator;
@property (strong, nonatomic) ContractCoordinator* ContractCoordinator;

@end

@implementation ProfileCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)start {
    
    self.profileViewController = (NSObject<ProfileOutput> *)[self.navigationController.viewControllers objectAtIndex:0];
    self.profileViewController.delegate = self;
}

- (void)showLanguage {
    
    self.languageCoordinator = [[LanguageCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.languageCoordinator startWithoutAnimation];
}

#pragma mark - ProfileOutputDelegate

- (void)didChangeFingerprintSettings:(BOOL)value {
    
    [[AppSettings sharedInstance] setFingerprintEnabled:value];
}

- (void)didPressedLanguage {
    
    self.languageCoordinator = [[LanguageCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.languageCoordinator start];
}

- (void)didPressedChangePin {
    
}

- (void)didPressedWalletBackup {
    
}

- (void)didPressedAbout {
    
}

- (void)didPressedThemes {
    
}

- (void)didPressedCreateToken {
    
    self.ContractCoordinator = [[ContractCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.ContractCoordinator start];
}

- (void)didPressedSubscribeToken {
    
    self.subscribeCoordinator = [[SubscribeTokenCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.subscribeCoordinator start];
}

- (void)didPressedLogout {
    
    [[ApplicationCoordinator sharedInstance] logout];
}

@end
