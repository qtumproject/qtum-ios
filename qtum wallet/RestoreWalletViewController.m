//
//  RestoreWalletViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RestoreWalletViewController.h"
#import "TextFieldWithLine.h"

@interface RestoreWalletViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *brandKeyTextView;
@property (strong,nonatomic) NSString *brainKeyString;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewBottomOffset;

- (IBAction)importButtonWasPressed:(id)sender;

@end

NSString* const textViewPlaceholder = @" Your Brain-CODE";


@implementation RestoreWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.brandKeyTextView.text = NSLocalizedString(textViewPlaceholder, "");
    [self.brandKeyTextView becomeFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

-(NSArray*)arrayOfWordsFromString:(NSString*)aString{
    NSArray *array = [aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    return array;
}


#pragma mark - Notification

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    self.gradientViewBottomOffset.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(textViewPlaceholder, "");
        self.brainKeyString = @"";
    } else {
        self.brainKeyString = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([textView.text isEqualToString:NSLocalizedString(textViewPlaceholder, "")]) {
        textView.text = @"";
    }
    return YES;
}


#pragma mark - QRCodeViewControllerDelegate

#pragma mark - Actions

- (IBAction)importButtonWasPressed:(id)sender
{
    [SVProgressHUD show];
    NSArray *wordsArray = [self arrayOfWordsFromString:self.brandKeyTextView.text];
    if ([self.delegate respondsToSelector:@selector(didRestorePressedWithWords:)]) {
        [self.delegate didRestorePressedWithWords:wordsArray];
    }
}

- (IBAction)cancelButtonTapped:(id)sender {
    if ([self.delegate respondsToSelector:@selector(restoreWalletCancelDidPressed)]) {
        [self.delegate restoreWalletCancelDidPressed];
    }
}

-(void)restoreSucces{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
    if ([self.delegate respondsToSelector:@selector(didRestoreWallet)]) {
        [self.delegate didRestoreWallet];
    }
}

-(void)restoreFailed{
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Some Error", "")];
}

- (IBAction)outsideTap:(id)sender
{
    [self.brandKeyTextView resignFirstResponder];
}


@end
