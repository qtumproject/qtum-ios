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

@interface LoginCoordinator () <LoginViewOutputDelegate>

@property (strong,nonatomic) UIViewController *containerViewController;
@property (weak,nonatomic) id <LoginViewOutput> loginController;

@end

@implementation LoginCoordinator

-(instancetype)initWithParentViewContainer:(UIViewController*) containerViewController {
    
    self = [super init];
    if (self) {
        _containerViewController = containerViewController;
    }
    return self;
}

-(void)start {
    
    LoginViewController* controller = (LoginViewController*)[[ControllersFactory sharedInstance] createLoginController];
    controller.delegate = self;
    [self displayContentController:controller];
    self.loginController = controller;
    
    if ([AppSettings sharedInstance].isFingerprintEnabled) {
        [self showFingerprint];
    }
}

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

-(void)loginUser {
    if ([self.delegate respondsToSelector:@selector(coordinatorDidLogin:)]) {
        [self hideContentController:(UIViewController*)self.loginController];
        [self.delegate coordinatorDidLogin:self];
    }
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
                                                [weakSelf confirmPasswordDidCanceled];
                                            });
                                            break;
                                        }
                                        default: {
                                            break;
                                        }
                                    }

                                }
                            }];
    }
}

-(void)passwordDidEntered:(NSString*)password {
    
    if ([password isEqualToString:[WalletManager sharedInstance].PIN]) {
        [self loginUser];
    }else {
        [self.loginController applyFailedPasswordAction];
    }
}

-(void)confirmPasswordDidCanceled{
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidCanceledLogin:)]) {
        [self hideContentController:(UIViewController*)self.loginController];
        [self.delegate coordinatorDidCanceledLogin:self];
    } else {
        [self hideContentController:(UIViewController*)self.loginController];
    }
}


@end
