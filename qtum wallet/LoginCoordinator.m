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
#import "NSUserDefaults+Settings.h"
#import "ErrorPopUpViewController.h"
#import "NSDate+Extension.h"

@interface LoginCoordinator () <LoginViewOutputDelegate, SecurityPopupViewControllerDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (strong,nonatomic) UIViewController *containerViewController;
@property (weak,nonatomic) id <LoginViewOutput> loginOutput;
@property (assign,nonatomic) NSUInteger failedPinCount;

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
    
    NSInteger failedCount = [NSUserDefaults getCountOfPinFailed];
    BOOL shodFingerprintShow = failedCount < 3;
    
    if (SLocator.appSettings.isFingerprintEnabled && shodFingerprintShow) {
        [self showFingerprint];
    } else {
        [self.loginOutput startEditing];
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

    if (![self checkStatusAndShowTimeAlertIfNeeded]) {
        
        if ([SLocator.walletManager verifyPin:pin] && [SLocator.walletManager startWithPin:pin]) {
            
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

#pragma mark -

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
