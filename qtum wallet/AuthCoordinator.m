//
//  AuthCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AuthCoordinator.h"
#import "FirstAuthViewController.h"
#import "WalletNameViewController.h"
#import "RestoreWalletViewController.h"
#import "RepeateViewController.h"
#import "CreatePinViewController.h"
#import "ExportWalletBrandKeyViewController.h"
#import "EnableFingerprintViewController.h"
#import "NSUserDefaults+Settings.h"

@interface AuthCoordinator () <FirstAuthOutputDelegate, WalletNameOutputDelegate, CreatePinOutputDelegate, RepeateOutputDelegate, ExportWalletBrandKeyOutputDelegate, RestoreWalletOutputDelegate, EnableFingerprintOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject<FirstAuthOutput> *firstController;
@property (nonatomic, weak) WalletNameViewController *createWalletController;
@property (nonatomic, weak) NSObject<RestoreWalletOutput> *restoreWalletOutput;
@property (nonatomic, weak) CreatePinViewController *createPinController;
@property (nonatomic, weak) RepeateViewController *repeatePinController;
@property (nonatomic, weak) NSObject<ExportWalletBrandKeyOutput> *exportWalletOutput;
@property (copy, nonatomic) NSString* firstPin;
@property (copy, nonatomic) NSString* walletName;
@property (copy, nonatomic) NSString* walletPin;
@property (copy, nonatomic) NSArray* walletBrainKey;
@property (assign, nonatomic, getter=isWalletRestored) BOOL walletRestored;

@end

@implementation AuthCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}
    
-(void)start{
    [self resetToRootAnimated:NO];
}

-(void)finishFlow {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidAuth:)]) {
        [self.delegate coordinatorDidAuth:self];
    }
}

-(void)resetToRootAnimated:(BOOL)animated {

    NSObject<FirstAuthOutput>* controller = (FirstAuthViewController*)[SLocator.controllersFactory createFirstAuthController];
    controller.delegate = self;
    animated ? [self.navigationController popToRootViewControllerAnimated:YES] : [self.navigationController setViewControllers:@[[controller toPresent]]];
    self.firstController = controller;
}

-(void)gotoCreateWallet {
    WalletNameViewController* controller = (WalletNameViewController*)[SLocator.controllersFactory createWalletNameCreateController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createWalletController = controller;
}

-(void)gotoRestoreWallet {
    
    NSObject<RestoreWalletOutput>* output = [SLocator.controllersFactory createRestoreWalletController];
    output.delegate = self;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    self.restoreWalletOutput = output;
}

-(void)gotoCreatePin {
    
    CreatePinViewController* controller = (CreatePinViewController*)[SLocator.controllersFactory createCreatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createPinController = controller;
}

-(void)gotoRepeatePin {
    
    RepeateViewController* controller = (RepeateViewController*)[SLocator.controllersFactory createRepeatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.repeatePinController = controller;
}

-(void)gotoFingerpringOption {
    EnableFingerprintViewController* controller = (EnableFingerprintViewController*)[SLocator.controllersFactory createEnableFingerprintViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)gotoExportWallet {
    
    NSObject<ExportWalletBrandKeyOutput>* output = (ExportWalletBrandKeyViewController*)[SLocator.controllersFactory createExportWalletBrandKeyViewController];
    output.delegate = self;
    output.brandKey = [SLocator.walletManager brandKeyWithPin:self.walletPin];
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    self.exportWalletOutput = output;
}

-(void)goToFinishWalletCreation {
    
    if (self.isWalletRestored) {
        [self finishFlow];
    } else {
        [self gotoExportWallet];
    }
}

-(void)gotoCreatePinAgain {
    
    self.walletPin = nil;
    [self resetToRootAnimated:YES];
    [self gotoCreatePin];
}

#pragma mark - Private

-(void)goToWalletFlow {
    
    [SLocator.walletManager storePin:self.walletPin];
    BOOL startingSuccess = [SLocator.walletManager startWithPin:self.walletPin];
    NSError* error = startingSuccess ? nil : [NSError new];
    [self.repeatePinController endCreateWalletWithError:error];
}

#pragma mark - FirstAuthOutputDelegate

-(void)didLoginPressed {
    
    [self.delegate coordinatorRequestForLogin];
}

-(void)didRestoreButtonPressed {
    
    [self gotoRestoreWallet];
}

-(void)didCreateNewButtonPressed {
    
    [self gotoCreatePin];
}

#pragma mark - WalletNameOutputDelegate

-(void)didCancelPressedOnWalletName {
    
    self.walletPin = nil;
    [self resetToRootAnimated:YES];
    self.walletRestored = NO;
}

-(void)didCreatedWalletPressedWithName:(NSString*)name {
    
    self.walletName = name;
    [self gotoCreatePin];
}

#pragma mark - CreatePinOutputDelegate

-(void)didCancelPressedOnCreateWallet {
    
    self.walletPin = nil;
    [self resetToRootAnimated:YES];
    self.walletRestored = NO;
}

-(void)didEntererFirstPin:(NSString*)pin {
    
    self.walletPin = pin;
    [self gotoRepeatePin];
}

#pragma mark - RepeateOutputDelegate

-(void)didCreateWalletPressed {
    
    [self didCreateWallet];
}

-(void)didCancelPressedOnRepeatePin {
    
    self.walletPin = nil;
    [self resetToRootAnimated:YES];
    self.walletRestored = NO;
}

-(void)didEnteredSecondPin:(NSString*)pin {
    
    __weak __typeof(self)weakSelf = self;
    if ([self.walletPin isEqualToString:pin] && !self.walletRestored) {
        
        [[ApplicationCoordinator sharedInstance] clear];
        [SLocator.walletManager createNewWalletWithName:self.walletName pin:self.walletPin withSuccessHandler:^(Wallet *newWallet) {
            
            [weakSelf goToWalletFlow];
        } andFailureHandler:^{
            
            [weakSelf.repeatePinController endCreateWalletWithError:[NSError new]];
        }];
    } else if ([self.walletPin isEqualToString:pin]) {
        
        [[ApplicationCoordinator sharedInstance] clear];
        [SLocator.walletManager createNewWalletWithName:self.walletName pin:self.walletPin seedWords:self.walletBrainKey withSuccessHandler:^(Wallet *newWallet) {
            
            [weakSelf goToWalletFlow];
        } andFailureHandler:^{
            
            [weakSelf.repeatePinController endCreateWalletWithError:[NSError new]];
        }];

    }else {

        [self.repeatePinController showFailedStatus];
    }
}

#pragma mark - ExportWalletBrandKeyOutputDelegate

-(void)didExportWalletPressed {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidAuth:)]) {
        [self.delegate coordinatorDidAuth:self];
    }
}

#pragma mark - RestoreWalletOutputDelegate

-(void)didRestorePressedWithWords:(NSString *)string {
    
    NSArray *words = [self arrayOfWordsFromString:string];
    if (words.count != brandKeyWordsCount) {
        [self.restoreWalletOutput restoreFailed];
    } else {
        self.walletBrainKey = words;
        [self.restoreWalletOutput restoreSucces];
    }
}

-(void)didRestoreWallet {
    
    self.walletRestored = YES;
    [self gotoCreatePin];
}

- (BOOL)checkWordsString:(NSString *)string {
    
    NSString *myRegex = @"[A-Za-z ]*";
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    if (![myTest evaluateWithObject:string]) {
        return NO;
    }
    
    NSArray *words = [self arrayOfWordsFromString:string];
    return words.count == brandKeyWordsCount;
}

-(void)restoreWalletCancelDidPressed {
    
    [self resetToRootAnimated:YES];
}

#pragma mark - EnableFingerprintOutputDelegate

-(void)didEnableFingerprint:(BOOL) enabled {
    
    [NSUserDefaults saveIsFingerpringEnabled:enabled];
    [self goToFinishWalletCreation];
}

-(void)didCancelEnableFingerprint {
    
    [NSUserDefaults saveIsFingerpringEnabled:NO];
    [self goToFinishWalletCreation];
}

#pragma mark - AuthCoordinatorDelegate

-(NSArray*)arrayOfWordsFromString:(NSString*)aString {
    
    NSArray *array = [aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    return array;
}

-(void)didCreateWallet {
    
    if ([NSUserDefaults isFingerprintAllowed]) {
        [self gotoFingerpringOption];
    } else {
        [self goToFinishWalletCreation];
    }
}

-(void)cancelCreateWallet {
    
    self.walletPin = nil;
    [self resetToRootAnimated:YES];
    self.walletRestored = NO;
}

-(void)didExportWallet {
    [self finishFlow];
}

@end
