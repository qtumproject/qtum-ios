//
//  SecurityPopupViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SecurityPopupViewController.h"
#import "SecurityPinView.h"

@interface SecurityPopupViewController () <UITextFieldDelegate, CAAnimationDelegate>

@end

@implementation SecurityPopupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configPasswordView];
    [self.passwordView becameFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

#pragma mark - Configuration

-(void)configPasswordView {
    
    self.passwordView.delegate = self;
}


#pragma mark PasswordViewDelegate

-(void)confirmPinWithDigits:(NSString*) digits {
    
    if ([self.delegate respondsToSelector:@selector(confirmButtonPressed:withPin:)]) {
        [self.delegate confirmButtonPressed:self withPin:digits];
    }
}

#pragma mark - Actions

- (IBAction)didPresseCancelAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(cancelButtonPressed:)]) {
        [self.delegate cancelButtonPressed:self];
    }
}

#pragma mark -

#pragma mark - LoginViewOutput

- (void)applyFailedPasswordAction {
    
    [self.passwordView accessPinDenied];
    [self.passwordView becameFirstResponder];
}


@end
