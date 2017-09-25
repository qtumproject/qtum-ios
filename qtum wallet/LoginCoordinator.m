//
//  LoginCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LoginCoordinator.h"
#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LoginViewOutputDelegate.h"
#import "LoginViewOutput.h"
#import "SecurityPopupViewController.h"
#import "FXKeychain.h"

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
    
    [self showSecurityLoginController];
    
    if ([AppSettings sharedInstance].isFingerprintEnabled) {
        [self showFingerprint];
    } else {
        [self.loginOutput startEditing];
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
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidCanceledLogin:)]) {
        [self.delegate coordinatorDidCanceledLogin:self];
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}


-(void)loginUser {
    
    if ([self.delegate respondsToSelector:@selector(coordinatorDidLogin:)]) {
        [self.delegate coordinatorDidLogin:self];
    }
    
    [self hideContentController:(UIViewController*)self.loginOutput];
}

-(void)enterPin:(NSString*) pin {
    
    if ([[ApplicationCoordinator sharedInstance].walletManager verifyPin:pin] && [[ApplicationCoordinator sharedInstance].walletManager startWithPin:pin]) {
        
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
