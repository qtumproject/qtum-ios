//
//  ConfirmPinCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ConfirmPinCoordinator.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"
#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ConfirmPinCoordinator () <LoginViewOutputDelegate>

@property (strong,nonatomic) UIViewController *containerViewController;
@property (weak,nonatomic) id <LoginViewOutput> loginOutput;

@end

@implementation ConfirmPinCoordinator

-(instancetype)initWithParentViewContainer:(UIViewController*) containerViewController {
    
    self = [super init];
    if (self) {
        _containerViewController = containerViewController;
    }
    return self;
}

#pragma mark - Coordinator

-(void)start {
    
    [self showSecurityLoginController];
    
    if ([AppSettings sharedInstance].isFingerprintEnabled) {
        [self showFingerprint];
    }
}

#pragma mark - Presentation

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
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidCanceledConfirm:)]) {
        [self.delegate coordinatorDidCanceledConfirm:self];
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}


-(void)loginUser {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidConfirm:)]) {
        [self.delegate coordinatorDidConfirm:self];
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
