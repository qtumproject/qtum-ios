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

@interface LoginCoordinator () <LoginCoordinatorDelegate>

@property (nonatomic,strong) UINavigationController *navigationController;
@property (weak,nonatomic) LoginViewController *loginController;

@end

@implementation LoginCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

-(void)start {
    [self showFingerprint];
}

-(void)showPinScreen {
    LoginViewController* controller = (LoginViewController*)[[ControllersFactory sharedInstance] createLoginController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:NO];
    self.loginController = controller;
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
                                        [weakSelf.delegate coordinatorDidLogin:weakSelf];
                                    });
                                } else {
                                    
                                    switch (error.code) {
                                        case kLAErrorSystemCancel:
                                        case kLAErrorAuthenticationFailed:
                                        case kLAErrorUserCancel: {
                                            
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf.delegate coordinatorDidCanceledLogin:weakSelf];
                                            });
                                            break;
                                        }
                                        default: {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [weakSelf showPinScreen];
                                            });
                                        }
                                    }

                                }
                            }];
    } else {
        
        [self showPinScreen];
    }
}

-(void)passwordDidEntered:(NSString*)password {
    
    if ([password isEqualToString:[WalletManager sharedInstance].PIN]) {
        if ([self.delegate respondsToSelector:@selector(coordinatorDidLogin:)]) {
            [self.delegate coordinatorDidLogin:self];
        }
    }else {
        [self.loginController applyFailedPasswordAction];
    }
}

-(void)confirmPasswordDidCanceled{
    if ([self.delegate respondsToSelector:@selector(coordinatorDidCanceledLogin:)]) {
        [self.delegate coordinatorDidCanceledLogin:self];
    }
}


@end
