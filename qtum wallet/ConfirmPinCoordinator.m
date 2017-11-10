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
#import "NSDate+Extension.h"
#import "ErrorPopUpViewController.h"
#import "NSUserDefaults+Settings.h"

@interface ConfirmPinCoordinator () <LoginViewOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

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
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    [self showSecurityLoginController];
    
    NSInteger failedCount = [NSUserDefaults getCountOfPinFailed];
    BOOL shoodFingerprintShow = failedCount < 3;

    if (SLocator.appSettings.isFingerprintEnabled && shoodFingerprintShow) {
        
        [self showFingerprint];
    } else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loginOutput startEditing];
        });
    }
}

#pragma mark - Presentation

-(void)showSecurityLoginController {
    
    LoginViewController* controller = (LoginViewController*)[SLocator.controllersFactory createLoginController];
    controller.delegate = self;
    [self displayContentController:controller];
    self.loginOutput = controller;
}

-(void)showFingerprint {

    __weak __typeof(self) weakSelf = self;
    
    [[TouchIDService sharedInstance] checkTouchIdWithText:NSLocalizedString(@"Login", nil) andCopmletion:^(TouchIDCompletionType type) {
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
    
    if (![self checkStatusAndShowTimeAlertIfNeeded]) {
        
        if ([SLocator.walletManager verifyPin:pin]) {
            
            [NSUserDefaults saveFailedPinCount:0];
            [self loginUser];
        }else {
            
            [self updaLastFailedTimeToNow];
            
            if (![self checkStatusAndShowTimeAlertIfNeeded]) {
                [self.loginOutput applyFailedPasswordAction];
            }
        }
    }
}


-(BOOL)checkStatusAndShowTimeAlertIfNeeded {
    
    NSInteger failedCount = [NSUserDefaults getCountOfPinFailed];
    NSDate* lastFailedPinDate = [NSUserDefaults getLastFailedPinDate];
    NSInteger minutsSinceLastFailed = [NSDate minutsSinceDate:lastFailedPinDate];
    NSInteger waitingMinuts = [SLocator.appSettings failedPinWaitingTime];
    BOOL isFailedStatePinEntering = failedCount >= 3 && lastFailedPinDate && minutsSinceLastFailed < waitingMinuts;
    
    if (isFailedStatePinEntering) {
        
        [self clearFieldsAndShowEnteringPinTimeFailedPopupWithMinuts:waitingMinuts - minutsSinceLastFailed];
        return YES;
    }
    
    return isFailedStatePinEntering;
}

-(void)clearFieldsAndShowEnteringPinTimeFailedPopupWithMinuts:(NSInteger) minuts {
    
    NSString* failedText = [NSString stringWithFormat:NSLocalizedString(@"Sorry, Please try again in %li minutes", nil),(long)minuts];
    [self showErrorPopUp:failedText];
    [self.loginOutput clearTextFileds];
    [self.loginOutput setInputsDisable:YES];
}

-(void)updaLastFailedTimeToNow {
    
    NSInteger failedCount = [NSUserDefaults getCountOfPinFailed];
    [NSUserDefaults saveFailedPinCount:++failedCount];
    [NSUserDefaults saveLastFailedPinDate:[NSDate new]];
}

#pragma mark - Popups

- (void)showErrorPopUp:(NSString *)message {
    
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (message) {
        content.messageString = message;
        content.titleString = NSLocalizedString(@"Failed", nil);
    }
    
    ErrorPopUpViewController *popUp = [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
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

#pragma mark - PopupDelegate

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [self.loginOutput setInputsDisable:NO];
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)confirmButtonPressed:(PopUpViewController *)sender withPin:(NSString*) pin {
    
    [self.loginOutput setInputsDisable:NO];
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [self.loginOutput setInputsDisable:NO];
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
