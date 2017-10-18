//
//  RepeateViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RepeateViewController.h"

@interface RepeateViewController () 

@end

@implementation RepeateViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configPasswordView];
    [self.passwordView setEditingDisabled:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.passwordView becameFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.passwordView setEditingDisabled:NO];
}

#pragma mark - Configuration

-(void)configPasswordView {
    self.passwordView.delegate = self;
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender{
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender {
    
    self.gradientViewBottomOffset.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - PasswordViewDelegate

-(void)confirmPinWithDigits:(NSString*) digits {
    
    if ([self.delegate respondsToSelector:@selector(didEnteredSecondPin:)]) {
        [self.delegate didEnteredSecondPin:digits];
    }
}

#pragma mark - Actions


- (IBAction)actionCancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didCancelPressedOnRepeatePin)]) {
        [self.delegate didCancelPressedOnRepeatePin];
    }
}

#pragma mark - Public Methods

-(void)endCreateWalletWithError:(NSError*)error {
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(didCancelPressedOnRepeatePin)]) {
            [self.delegate didCancelPressedOnRepeatePin];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(didCreateWalletPressed)]) {
            [self.delegate didCreateWalletPressed];
        }
    }
}

-(void)showFailedStatus {
    
    [self.passwordView accessPinDenied];
}


@end
