//
//  ConfirmPinForExportViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPinForExportViewController.h"
#import "Presentable.h"

@interface ConfirmPinForExportViewController () <CAAnimationDelegate, Presentable>

@property (assign, nonatomic) BOOL shoudKeboardDismiss;
@property (assign, nonatomic) BOOL editingStarted;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@implementation ConfirmPinForExportViewController

@synthesize delegate;

- (void)viewDidLoad {

	[super viewDidLoad];

	NSInteger textfieldsWithButtonHeight = 250;

	self.bottomConstraintForCancelButton.constant = self.view.frame.size.height / 2. - textfieldsWithButtonHeight / 2.;

	[self configPasswordView];
}

- (void)willMoveToParentViewController:(UIViewController *) parent {

}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];
	if (self.editingStarted) {
		[self startEditing];
	}
}

- (void)viewWillDisappear:(BOOL) animated {

	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

- (void)configPasswordView {

	self.passwordView.delegate = self;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.bottomConstraintForCancelButton.constant = end.size.height;
	[self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *) sender {

	dispatch_async (dispatch_get_main_queue (), ^{
		[self startEditing];
	});
}

- (void)startEditing {

	self.editingStarted = YES;
	[self.passwordView clearPinTextFields];
	[self.passwordView becameFirstResponder];
}

- (void)stopEditing {

	self.editingStarted = NO;
	[self.view endEditing:YES];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions

#pragma mark PasswordViewDelegate

- (void)confirmPinWithDigits:(NSString *) digits {

	self.shoudKeboardDismiss = YES;

	if ([self.delegate respondsToSelector:@selector (passwordDidEntered:)]) {
		[self.delegate passwordDidEntered:digits];
	}
}

- (IBAction)actionCancel:(id) sender {
	self.shoudKeboardDismiss = YES;
	if ([self.delegate respondsToSelector:@selector (confirmPasswordDidCanceled)]) {
		[self.delegate confirmPasswordDidCanceled];
	}
}

- (void)showLoginFields {

	self.passwordView.hidden = NO;
	self.cancelButton.hidden = NO;
	[self.passwordView becameFirstResponder];
}

- (void)applyFailedPasswordAction {

	[self.passwordView accessPinDenied];
	[self.passwordView clearPinTextFields];
	[self.passwordView becameFirstResponder];
}

- (IBAction)didVoidTapAction:(id) sender {

	//    if (!([self.firstSymbolTextField isFirstResponder] ||
	//        [self.secondSymbolTextField isFirstResponder] ||
	//        [self.thirdSymbolTextField isFirstResponder] ||
	//        [self.fourthSymbolTextField isFirstResponder])) {
	//
	//        [self.firstSymbolTextField becomeFirstResponder];
	//    }
}


@end
