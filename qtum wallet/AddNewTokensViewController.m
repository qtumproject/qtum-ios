//
//  AddNewTokensViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AddNewTokensViewController.h"
#import "SubscribeTokenCoordinator.h"
#import "TextFieldWithLine.h"

const CGFloat TextFieldAlpha = 0.3f;

@interface AddNewTokensViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenAddressTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)acitonBack:(id)sender;
- (IBAction)actionAddTokens:(id)sender;

@end

@implementation AddNewTokensViewController

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
    
    self.tokenAddressTextField.delegate = self;
    self.scrollView.delegate = self;
}

#pragma mark - Notifications Handlers

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, end.size.height, 0.0f);
    self.scrollView.contentInset = insets;
}

-(void)keyboardWillHide:(NSNotification *)sender{
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma mark - Actions

- (IBAction)acitonBack:(id)sender
{
    [self.delegate didBackButtonPressed];
}

- (IBAction)actionAddTokens:(id)sender
{
    
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.lineView.alpha = 1.0f;
    self.tokenAddressTextField.alpha = 1.0f;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString: @""]) {
        self.lineView.alpha = TextFieldAlpha;
        self.tokenAddressTextField.alpha = TextFieldAlpha;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma maek - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.tokenAddressTextField resignFirstResponder];
}

@end
