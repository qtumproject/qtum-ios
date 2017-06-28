//
//  LoginCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LoginCoordinator.h"
#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginViewOutputDelegate.h"
#import "LoginViewOutput.h"
#import "SecurityPopupViewController.h"

@interface LoginCoordinator () <LoginViewOutputDelegate, SecurityPopupViewControllerDelegate>

@property (strong,nonatomic) UIViewController *containerViewController;
@property (weak,nonatomic) id <LoginViewOutput> loginOutput;

@end

@implementation LoginCoordinator

-(instancetype)initWithParentViewContainer:(UIViewController*) containerViewController {
    
    self = [super init];
    if (self) {
        _containerViewController = containerViewController;
    }
    return self;
}

#pragma mark - Coordinator

-(void)start {
    
    if (self.type == SecurityPopup && ![AppSettings sharedInstance].isFingerprintEnabled) {
        
        [self showSecurityPopup];
    } else if (self.type == SecurityController || self.type == LoginController) {
        
        [self showSecurityLoginController];
    }

    if ([AppSettings sharedInstance].isFingerprintEnabled) {
        [self showFingerprint];
    }
}

#pragma mark - Presentation

-(void)showSecurityPopup {
    SecurityPopupViewController* controller = [[PopUpsManager sharedInstance] showSecurityPopup:self presenter:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
    controller.delegate = self;
    self.loginOutput = controller;
}

-(void)showSecurityLoginController {
    
    LoginViewController* controller = (LoginViewController*)[[ControllersFactory sharedInstance] createLoginController];
    controller.delegate = self;
    [self displayContentController:controller];
    self.loginOutput = controller;
}

-(void)showFingerprint {
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *reason = @"Login";
    
    __weak __typeof(self) weakSelf = self;

    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:reason
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf loginUser];
                                    });
                                } else {
                                    
                                    switch (error.code) {
                                        case kLAErrorSystemCancel:
                                        case kLAErrorAuthenticationFailed:
                                        case kLAErrorUserCancel: {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf cancelPin];
                                            });
                                            break;
                                        }
                                        case kLAErrorUserFallback: {
                                            if (weakSelf.type == SecurityPopup) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [weakSelf showSecurityPopup];
                                                });
                                            }
                                        }
                                        default: {
                                            break;
                                        }
                                    }

                                }
                            }];
    }
}

#pragma mark - Actions

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [self cancelPin];
}

- (void)confirmButtonPressed:(PopUpViewController *)sender withPin:(NSString*) pin {
    
    [self enterPin:pin];
}

-(void)passwordDidEntered:(NSString*)password {
    
    [self enterPin:password];
}

-(void)confirmPasswordDidCanceled {
    
    [self cancelPin];
}

#pragma mark - Private Methods

-(void)cancelPin {
    
    switch (self.type) {
            
        case SecurityController:
        case SecurityPopup: {
            if ([self.delegate respondsToSelector:@selector(coordinatorDidCancelePassSecurity:)]) {
                [self.delegate coordinatorDidCancelePassSecurity:self];
            }
        }
            break;
        case LoginController: {
            if ([self.delegate respondsToSelector:@selector(coordinatorDidCanceledLogin:)]) {
                [self.delegate coordinatorDidCanceledLogin:self];
            }
        }
            break;
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}


-(void)loginUser {
    
    switch (self.type) {
            
        case SecurityController:
        case SecurityPopup: {
            if ([self.delegate respondsToSelector:@selector(coordinatorDidPassSecurity:)]) {
                [self.delegate coordinatorDidPassSecurity:self];
            }
        }
            break;
        case LoginController: {
            if ([self.delegate respondsToSelector:@selector(coordinatorDidLogin:)]) {
                [self.delegate coordinatorDidLogin:self];
            }
        }
            break;
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}

-(void)enterPin:(NSString*) password {
    
    if ([password isEqualToString:[WalletManager sharedInstance].PIN]) {
        [self loginUser];
    }else {
        [self.loginOutput applyFailedPasswordAction];
    }
}

#pragma mark - Add/Remove from parent

- (void)displayContentController: (UIViewController*) content {
    
    [self.containerViewController addChildViewController:content];
    content.view.frame = self.containerViewController.view.frame;
    [self.containerViewController.view addSubview:content.view];
    [content didMoveToParentViewController:self.containerViewController];
}

- (void) hideContentController: (UIViewController*) content {
    
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

@end
