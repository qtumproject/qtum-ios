//
//  ProfileCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ProfileCoordinator.h"
#import "ProfileOutput.h"
#import "LanguageOutput.h"
#import "ExportBrainKeyOutput.h"

#import "SubscribeTokenCoordinator.h"
#import "ContractCoordinator.h"
#import "ExportBrandKeyCoordinator.h"
#import "ChangePinCoordinator.h"
#import "AboutOutput.h"
#import "ErrorPopUpViewController.h"

@interface ProfileCoordinator() <ProfileOutputDelegate, LanguageOutputDelegate, ExportBrandKeyCoordinatorDelegate, ChangePinCoordinatorDelegate, AboutOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

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

#pragma mark - ChangePinCoordinatorDelegate

- (void)coordinatorDidFinish:(ChangePinCoordinator*)coordinator {
    
    [self removeDependency:coordinator];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ProfileOutputDelegate

- (void)didChangeFingerprintSettings:(BOOL)value {
    
    [[AppSettings sharedInstance] setFingerprintEnabled:value];
}

- (void)didPressedLanguage {
    
    [self showLanguage:YES];
}

- (void)didPressedChangePin {
    
    ChangePinCoordinator* coordinator = [[ChangePinCoordinator alloc] initWithNavigationController:self.navigationController];
    coordinator.delegate = self;
    [coordinator start];
    [self addDependency:coordinator];
}

- (void)didPressedWalletBackup {
    
    ExportBrandKeyCoordinator* coordinator = [[ExportBrandKeyCoordinator alloc] initWithNavigationController:self.navigationController];
    coordinator.delegate = self;
    [coordinator start];
    [self addDependency:coordinator];
}

- (void)didPressedAbout {
    NSObject<AboutOutput>* output = [[ControllersFactory sharedInstance] createAboutOutput];
    output.delegate = self;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

- (void)didPressedThemes {
    [[ApplicationCoordinator sharedInstance] startChanginTheme];
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
    
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    content.messageString = NSLocalizedString(@"You are about to exit your account. All account data will be erased from the device. Please make sure you have saved back-ups of your Passphrase and required Contracts", nil);
    content.titleString = NSLocalizedString(@"Warning", nil);
    content.okButtonTitle = NSLocalizedString(@"Logout", nil);
    content.cancelButtonTitle = NSLocalizedString(@"Cancel", nil);

    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
}

#pragma mark - PopupDelegate

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [[ApplicationCoordinator sharedInstance] logout];
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
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
