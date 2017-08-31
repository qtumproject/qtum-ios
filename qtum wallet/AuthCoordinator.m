//
//  AuthCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
#import "FirstAuthOutputDelegate.h"
#import "WalletNameOutputDelegate.h"
#import "CreatePinOutputDelegate.h"
#import "RepeateOutputDelegate.h"
#import "ExportWalletBrandKeyOutputDelegate.h"
#import "Wallet.h"

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
@property (assign, nonatomic, getter=isWalletExported) BOOL walletExported;

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

-(void)resetToRootAnimated:(BOOL)animated {

    NSObject<FirstAuthOutput>* controller = (FirstAuthViewController*)[[ControllersFactory sharedInstance] createFirstAuthController];
    controller.delegate = self;
    animated ? [self.navigationController popToRootViewControllerAnimated:YES] : [self.navigationController setViewControllers:@[[controller toPresent]]];
    self.firstController = controller;
}

-(void)gotoCreateWallet {
    WalletNameViewController* controller = (WalletNameViewController*)[[ControllersFactory sharedInstance] createWalletNameCreateController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createWalletController = controller;
}

-(void)gotoRestoreWallet {
    
    NSObject<RestoreWalletOutput>* output = [[ControllersFactory sharedInstance] createRestoreWalletController];
    output.delegate = self;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    self.restoreWalletOutput = output;
}

-(void)gotoCreatePin {
    
    CreatePinViewController* controller = (CreatePinViewController*)[[ControllersFactory sharedInstance] createCreatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.createPinController = controller;
}

-(void)gotoRepeatePin {
    
    RepeateViewController* controller = (RepeateViewController*)[[ControllersFactory sharedInstance] createRepeatePinController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    self.repeatePinController = controller;
}

-(void)gotoFingerpringOption {
    EnableFingerprintViewController* controller = (EnableFingerprintViewController*)[[ControllersFactory sharedInstance] createEnableFingerprintViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)gotoExportWallet {
    
    NSObject<ExportWalletBrandKeyOutput>* output = (ExportWalletBrandKeyViewController*)[[ControllersFactory sharedInstance] createExportWalletBrandKeyViewController];
    output.delegate = self;
    output.brandKey = [[ApplicationCoordinator sharedInstance].walletManager brandKeyWithPin:self.walletPin];
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    self.exportWalletOutput = output;
}

-(void)gotoCreatePinAgain{
    [self resetToRootAnimated:YES];
    [self gotoCreatePin];
}

#pragma mark - FirstAuthOutputDelegate

-(void)didLoginPressed {
    
    [self.delegate coordinatorRequestForLogin];
}

-(void)didRestoreButtonPressed {
    
    [self gotoRestoreWallet];
}

-(void)didCreateNewButtonPressed {
    
    [self gotoCreateWallet];
}

#pragma mark - WalletNameOutputDelegate

-(void)didCancelPressedOnWalletName {
    
    [self resetToRootAnimated:YES];
    self.walletExported = NO;
}

-(void)didCreatedWalletPressedWithName:(NSString*)name {
    
    self.walletName = name;
    [self gotoCreatePin];
}

#pragma mark - CreatePinOutputDelegate

-(void)didCancelPressedOnCreateWallet {
    
    [self resetToRootAnimated:YES];
    self.walletExported = NO;
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
    
    [self resetToRootAnimated:YES];
    self.walletExported = NO;
}

-(void)didEnteredSecondPin:(NSString*)pin {
    
    __weak __typeof(self)weakSelf = self;
    if ([self.walletPin isEqualToString:pin] && !self.isWalletExported) {
        
        [[ApplicationCoordinator sharedInstance] clear];
        [[ApplicationCoordinator sharedInstance].walletManager createNewWalletWithName:self.walletName pin:self.walletPin withSuccessHandler:^(Wallet *newWallet) {
            
            [[ApplicationCoordinator sharedInstance].walletManager storePin:weakSelf.walletPin];
            [[ApplicationCoordinator sharedInstance].walletManager startWithPin:weakSelf.walletPin];
            [weakSelf.repeatePinController endCreateWalletWithError:nil];
        } andFailureHandler:^{
            [weakSelf.repeatePinController endCreateWalletWithError:[NSError new]];
        }];
    } else if ([self.walletPin isEqualToString:pin]) {
        
        [[ApplicationCoordinator sharedInstance] clear];
        [[ApplicationCoordinator sharedInstance].walletManager createNewWalletWithName:self.walletName pin:self.walletPin seedWords:self.walletBrainKey withSuccessHandler:^(Wallet *newWallet) {
            [[ApplicationCoordinator sharedInstance].walletManager storePin:weakSelf.walletPin];
            [[ApplicationCoordinator sharedInstance].walletManager startWithPin:weakSelf.walletPin];
            [weakSelf.repeatePinController endCreateWalletWithError:nil];
        } andFailureHandler:^{
            [weakSelf.repeatePinController endCreateWalletWithError:[NSError new]];
        }];

    }else {
        self.walletPin = nil;
        [self gotoCreatePinAgain];
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
    
    self.walletExported = YES;
    [self gotoCreateWallet];
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
    [self gotoExportWallet];
}

-(void)didCancelEnableFingerprint {
    
    [NSUserDefaults saveIsFingerpringEnabled:NO];
    [self gotoExportWallet];
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
        [self gotoExportWallet];
    }
}

-(void)cancelCreateWallet{
    [self resetToRootAnimated:YES];
    self.walletExported = NO;
}

-(void)didExportWallet {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidAuth:)]) {
        [self.delegate coordinatorDidAuth:self];
    }
}


@end
