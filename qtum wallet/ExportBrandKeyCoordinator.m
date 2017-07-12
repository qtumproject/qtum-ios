//
//  ExportWalletCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 12.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ExportBrandKeyCoordinator.h"
#import "ExportBrainKeyOutput.h"
#import "ExportBrainKeyOutputDelegate.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"

@interface ExportBrandKeyCoordinator () <ExportBrainKeyOutputDelegate, LoginViewOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject<ExportBrainKeyOutput> *exportBrainKeyController;
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

-(void)enterPin:(NSString*) password {
    
    if ([password isEqualToString:[WalletManager sharedInstance].PIN]) {
        [self showExportOutput];
    }else {
        [self.loginOutput applyFailedPasswordAction];
    }
}

-(void)showSecurityLoginOutput {
    
    NSObject<LoginViewOutput>* controller = [[ControllersFactory sharedInstance] createLoginController];
    controller.delegate = self;
    [controller startEditing];
    self.loginOutput = controller;
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

-(void)showExportOutput {
    
    self.exportBrainKeyController = [[ControllersFactory sharedInstance] createExportBrainKeyViewController];
    self.exportBrainKeyController.delegate = self;
    [self.navigationController pushViewController:[self.exportBrainKeyController toPresent] animated:YES];
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
