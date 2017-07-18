//
//  ExportWalletCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ExportBrandKeyCoordinator.h"
#import "ExportBrainKeyOutput.h"
#import "ExportBrainKeyOutputDelegate.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"

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
}

#pragma mark - Private Methods 

-(void)enterPin:(NSString*) pin {
    
    if ([[WalletManager sharedInstance] verifyPin:pin]) {
        [self showExportOutputWithPin:pin];
    }else {
        [self.loginOutput applyFailedPasswordAction];
    }
}

-(void)showSecurityLoginOutput {
    
    NSObject<LoginViewOutput>* controller = [[ControllersFactory sharedInstance] createConfirmPinForExportViewController];
    controller.delegate = self;
    [controller startEditing];
    self.loginOutput = controller;
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

-(void)showExportOutputWithPin:(NSString*) pin {
    
    self.exportBrainKeyOutput = [[ControllersFactory sharedInstance] createExportBrainKeyViewController];
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
