//
//  RestoreWalletViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RestoreWalletViewController.h"
#import "TextFieldWithLine.h"

@interface RestoreWalletViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *brandKeyTextView;
@property (strong, nonatomic) NSString *brainKeyString;
@property (weak, nonatomic) IBOutlet UIButton *importButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)importButtonWasPressed:(id) sender;

@end

@implementation RestoreWalletViewController

@synthesize delegate;

#pragma mark - Lifecycle

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
	self.brandKeyTextView.text = NSLocalizedString(@"Your Passphrase", "");
	[self.brandKeyTextView becomeFirstResponder];
	[self setupImportButton];
    [self configLocalization];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    [self.importButton setTitle:NSLocalizedString(@"IMPORT", @"Import Wallet IMPORT Button") forState:UIControlStateNormal];
    [self.cancelButton setTitle:NSLocalizedString(@"CANCEL", @"Import Wallet CANCEL Button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Import Wallet", @"Import Wallet Controllers Title");
}


#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification *) sender {
	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.bottomForButtonsConstraint.constant = end.size.height;
	[self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *) sender {
	self.bottomForButtonsConstraint.constant = 0;
	[self.view layoutIfNeeded];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *) textField {
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *) textView {
	if ([textView.text isEqualToString:NSLocalizedString(@"Your Passphrase", "")]) {
		textView.selectedRange = NSMakeRange (0, 0);
	}
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *) textView {
	if (textView.text.length == 0) {
		textView.text = NSLocalizedString(@"Your Passphrase", "");
		self.brainKeyString = @"";
	} else {
		self.brainKeyString = textView.text;
	}
}

- (BOOL)textView:(UITextView *) textView shouldChangeTextInRange:(NSRange) range replacementText:(NSString *) text {
	if ([textView.text isEqualToString:NSLocalizedString(@"Your Passphrase", "")]) {
		textView.text = @"";
	}
	return YES;
}

- (void)textViewDidChange:(UITextView *) textView {

	[self setupImportButton];
}

#pragma mark - Private

- (void)setupImportButton {

	if ([self.delegate respondsToSelector:@selector (checkWordsString:)]) {
		self.importButton.alpha = [self.delegate checkWordsString:self.brandKeyTextView.text] ? 1.0f : 0.7f;
		self.importButton.enabled = [self.delegate checkWordsString:self.brandKeyTextView.text];
	}
}

#pragma mark - Actions

- (IBAction)importButtonWasPressed:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didRestorePressedWithWords:)]) {
		[self.delegate didRestorePressedWithWords:self.brandKeyTextView.text];
	}
}

- (IBAction)cancelButtonTapped:(id) sender {
	if ([self.delegate respondsToSelector:@selector (restoreWalletCancelDidPressed)]) {
		[self.delegate restoreWalletCancelDidPressed];
	}
}

- (void)restoreSucces {
	[SLocator.popupService dismissLoader];
	[SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
	if ([self.delegate respondsToSelector:@selector (didRestoreWallet)]) {
		[self.view endEditing:YES];
		[self.delegate didRestoreWallet];
	}
}

- (void)restoreFailed {
	[SLocator.popupService dismissLoader];
	[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Some Error", "")];
}

- (IBAction)outsideTap:(id) sender {
	[self.brandKeyTextView resignFirstResponder];
}


@end
