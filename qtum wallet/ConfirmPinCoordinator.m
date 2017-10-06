//
//  ConfirmPinCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPinCoordinator.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"
#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "TouchIDService.h"

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
        
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
        [self showFingerprint];
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginOutput startEditing];
        });
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
    
    [[TouchIDService sharedInstance] checkTouchId:^(TouchIDCompletionType type) {
        switch (type) {
                
            case TouchIDSuccessed:
                
                [weakSelf loginUser];
                break;
                
            case TouchIDDenied:
            case TouchIDCanceled:
                
                [weakSelf.loginOutput startEditing];
                break;
        }
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

-(void)enterPin:(NSString*) pin {
    
    if ([[ApplicationCoordinator sharedInstance].walletManager verifyPin:pin]) {
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
