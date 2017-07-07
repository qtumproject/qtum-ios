//
//  SecurityCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SecurityCoordinator.h"
#import "LoginViewOutput.h"
#import "SecurityPopupViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginViewOutputDelegate.h"

@interface SecurityCoordinator () <SecurityPopupViewControllerDelegate>

@property (strong,nonatomic) UIViewController *containerViewController;
@property (weak,nonatomic) id <LoginViewOutput> loginOutput;

@end

@implementation SecurityCoordinator

-(instancetype)initWithParentViewContainer:(UIViewController*) containerViewController {
    
    self = [super init];
    if (self) {
        _containerViewController = containerViewController;
    }
    return self;
}

-(void)start {
    
    if ([AppSettings sharedInstance].isFingerprintEnabled) {
        
        [self showFingerprint];
    } else {
        
        [self showSecurityPopup];
    }

}

-(void)showSecurityPopup {
    
    SecurityPopupViewController* controller = [[PopUpsManager sharedInstance] showSecurityPopup:self presenter:nil completion:nil];
    controller.delegate = self;
    self.loginOutput = controller;
}

-(void)showFingerprint {
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *reason = @"Login";
    
    __weak __typeof(self) weakSelf = self;
    
    CGFloat touchIdDelayAnimation = 0.25;

    
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
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(touchIdDelayAnimation * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                [weakSelf showSecurityPopup];

                                            });
                                        }
                                        default: {
                                            break;
                                        }
                                    }
                                    
                                }
                            }];
    } else {
        [self showSecurityPopup];
    }
}

#pragma mark - Private Methods

-(void)cancelPin {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidCancelePassSecurity:)]) {
        [self.delegate coordinatorDidCancelePassSecurity:self];
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}


-(void)loginUser {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidPassSecurity:)]) {
        [self.delegate coordinatorDidPassSecurity:self];
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

#pragma mark - SecurityPopupViewControllerDelegate

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [self cancelPin];
}

- (void)confirmButtonPressed:(PopUpViewController *)sender withPin:(NSString*) pin {
    [self enterPin:pin];
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
