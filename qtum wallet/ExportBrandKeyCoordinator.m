//
//  ExportWalletCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ExportBrandKeyCoordinator.h"
#import "ExportBrainKeyOutput.h"
#import "ExportBrainKeyOutputDelegate.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"
#import "FXKeychain.h"

@interface ExportBrandKeyCoordinator () <ExportBrainKeyOutputDelegate, LoginViewOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject<ExportBrainKeyOutput> *exportBrainKeyOutput;
@property (weak,nonatomic) id <LoginViewOutput> loginOutput;

@end

@implementation ExportBrandKeyCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

- (void)start {
    
    [self showSecurityLoginOutput];
    
    if (SLocator.appSettings.isFingerprintEnabled) {
        
        [self showFingerprint];
    } else {
        
        [self.loginOutput startEditing];
    }
}

#pragma mark - Private Methods 

-(void)enterPin:(NSString*) pin {
    
    if ([[ApplicationCoordinator sharedInstance].walletManager verifyPin:pin]) {
        [self showExportOutputWithPin:pin];
    }else {
        [self.loginOutput applyFailedPasswordAction];
    }
}

-(void)showSecurityLoginOutput {
    
    NSObject<LoginViewOutput>* controller = [[ControllersFactory sharedInstance] createConfirmPinForExportViewController];
    controller.delegate = self;
    self.loginOutput = controller;
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

-(void)showFingerprint {
    
    __weak __typeof(self) weakSelf = self;
    
    [[FXKeychain defaultKeychain] touchIDString:^(NSString * _Nullable string, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (string) {
                [weakSelf enterPin:string];
            } else {
                [weakSelf.loginOutput startEditing];
            }
        });
    }];
}

-(void)showExportOutputWithPin:(NSString*) pin {
    
    self.exportBrainKeyOutput = [[ControllersFactory sharedInstance] createExportBrainKeyViewController];
    self.exportBrainKeyOutput.brandKey = [[ApplicationCoordinator sharedInstance].walletManager brandKeyWithPin:pin];
    self.exportBrainKeyOutput.delegate = self;
    [self.navigationController pushViewController:[self.exportBrainKeyOutput toPresent] animated:YES];
}

#pragma mark - ExportBrainKeyOutputDelegate

- (void)didBackPressed {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - LoginViewOutputDelegate

-(void)passwordDidEntered:(NSString*)password {
    
    [self enterPin:password];
}

-(void)confirmPasswordDidCanceled {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
