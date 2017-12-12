//
//  CreatePinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "CreatePinViewController.h"

@interface CreatePinViewController () <CAAnimationDelegate>

@property (assign, nonatomic, getter = isProcessing) BOOL processing;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation CreatePinViewController

@synthesize delegate;

#pragma mark - Lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
	[self configPasswordView];
    [self configLocalization];
	[self.passwordView becameFirstResponder];
}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];
	[self.passwordView becameFirstResponder];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    [self.cancelButton setTitle:NSLocalizedString(@"CANCEL", @"Cancel Button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Create PIN", @"Create PIN Controllers Title");
}

- (void)configPasswordView {
	self.passwordView.delegate = self;
}

#pragma mark - PasswordViewDelegate

- (void)confirmPinWithDigits:(NSString *) digits {

	[self.view endEditing:YES];

	if ([self.delegate respondsToSelector:@selector (didEntererFirstPin:)]) {
		[self.delegate didEntererFirstPin:digits];
	}
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.gradientViewBottomOffset.constant = end.size.height;
	[self.view layoutIfNeeded];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions

- (IBAction)actionCancel:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didCancelPressedOnCreateWallet)]) {
		[self.delegate didCancelPressedOnCreateWallet];
	}
}

@end
