//
//  WalletNameViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "WalletNameViewController.h"

@interface WalletNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation WalletNameViewController

@synthesize delegate;

- (void)viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];

	[self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.buttonsBottomConstraint.constant = end.size.height;
	[self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *) sender {

}

#pragma mark - Actions

- (IBAction)actionConfirm:(id) sender {

	[self.nameTextField resignFirstResponder];
	if ([self.delegate respondsToSelector:@selector (didCreatedWalletPressedWithName:)]) {
		[self.delegate didCreatedWalletPressedWithName:self.nameTextField.text];
	}
}

- (IBAction)cancelButtonPressed:(id) sender {

	[self.nameTextField resignFirstResponder];
	if ([self.delegate respondsToSelector:@selector (didCancelPressedOnWalletName)]) {
		[self.delegate didCancelPressedOnWalletName];
	}
}


@end
