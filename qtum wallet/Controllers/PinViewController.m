//
//  PinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "PinViewController.h"
#import "Presentable.h"

const float bottomOffsetKeyboard = 300;
const float bottomOffset = 25;

@interface PinViewController () <UITextFieldDelegate, CAAnimationDelegate, Presentable>

@property (weak, nonatomic) IBOutlet UILabel *controllerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonBottomOffset;

@end

@implementation PinViewController

@synthesize delegate;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configPasswordView];
}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];
	[self.passwordView becameFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Configuration

- (void)configPasswordView {

	self.passwordView.delegate = self;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];

	UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
	CGFloat tapBarHeight = 0.0f;
	if ([vc isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tapBarVC = (UITabBarController *)vc;
		tapBarHeight = tapBarVC.tabBar.frame.size.height;
	}

	self.bottomForButtonsConstraint.constant = end.size.height - tapBarHeight;
	[self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *) sender {

	dispatch_async (dispatch_get_main_queue (), ^{
		[self.passwordView becameFirstResponder];
	});
}

#pragma mark - Configuration

#pragma mark - Privat Methods

- (void)checkPinWithDigits:(NSString *) digits {

	__weak typeof (self) weakSelf = self;

	[self.delegate confirmPin:digits andCompletision:^(BOOL success) {
		if (success) {
			[weakSelf.view endEditing:YES];
		} else {
			[weakSelf.passwordView accessPinDenied];
		}
		[weakSelf.passwordView clearPinTextFields];
		[weakSelf.passwordView becameFirstResponder];
	}];
}

#pragma mark PasswordViewDelegate

- (void)confirmPinWithDigits:(NSString *) digits {

	[self checkPinWithDigits:digits];
}

- (void)changeConstraintsAnimatedWithTime:(NSTimeInterval) time {

	[UIView animateWithDuration:time animations:^{
		[self.view layoutIfNeeded];
	}];
}

#pragma mark - Actions


- (IBAction)actionCancel:(id) sender {

	[self.delegate didPressedCancel];
}

- (IBAction)actionEnterPin:(id) sender {


	[self checkPinWithDigits:[self.passwordView getDigits]];

}

#pragma mark -

- (void)setCustomTitle:(NSString *) title {

	self.controllerTitle.text = title;
}

- (IBAction)actionBack:(id) sender {

	[self.delegate didPressedBack];
}

@end



