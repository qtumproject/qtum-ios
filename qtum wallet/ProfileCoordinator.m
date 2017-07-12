//
//  ProfileCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ProfileCoordinator.h"
#import "ProfileOutput.h"
#import "LanguageOutput.h"
#import "ExportBrainKeyOutput.h"

#import "SubscribeTokenCoordinator.h"
#import "ContractCoordinator.h"
#import "ExportBrandKeyCoordinator.h"

@interface ProfileCoordinator() <ProfileOutputDelegate, LanguageOutputDelegate, ExportBrandKeyCoordinatorDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, weak) NSObject<ProfileOutput> *profileViewController;
@property (nonatomic, weak) NSObject<LanguageOutput> *languageController;

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

- (void)startFromLanguage {
    
    [self start];
    [self showLanguage:NO];
}

- (void)showLanguage:(BOOL)animated {
    
    self.languageController = [[ControllersFactory sharedInstance] createLanguageViewController];
    self.languageController.delegate = self;
    [self.navigationController pushViewController:[self.languageController toPresent] animated:animated];
}

#pragma mark - ExportBrandKeyCoordinatorDelegate

- (void)coordinatorDidEnd:(ExportBrandKeyCoordinator*)coordinator {
    
    [self removeDependency:coordinator];
}

#pragma mark - ProfileOutputDelegate

- (void)didChangeFingerprintSettings:(BOOL)value {
    
    [[AppSettings sharedInstance] setFingerprintEnabled:value];
}

- (void)didPressedLanguage {
    
    [self showLanguage:YES];
}

- (void)didPressedChangePin {
    
    
}

- (void)didPressedWalletBackup {
    
    ExportBrandKeyCoordinator* coordinator = [[ExportBrandKeyCoordinator alloc] initWithNavigationController:self.navigationController];
    coordinator.delegate = self;
    [coordinator start];
    [self addDependency:coordinator];
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

#pragma mark - LanguageOutputDelegate

- (void)didLanguageChanged {
    
    [[ApplicationCoordinator sharedInstance] startChangedLanguageFlow];
}

#pragma mark - Back

- (void)didBackPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
