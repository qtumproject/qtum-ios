//
//  CreateTokenStep1ViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenStep1ViewController.h"
#import "CreateTokenCoordinator.h"
#import "TextFieldWithLine.h"

@interface CreateTokenStep1ViewController ()

@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenNameTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenSymbolTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomOffset;

@end

static NSInteger baseButtonsButtomOffset = 30;

@implementation CreateTokenStep1ViewController


#pragma mark Life Cycle

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
    [self.tokenNameTextField becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notificztions Handlers

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.buttonsBottomOffset.constant = end.size.height + baseButtonsButtomOffset;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    self.buttonsBottomOffset.constant = baseButtonsButtomOffset;
    [self.view layoutIfNeeded];
}

#pragma mark Actions

- (IBAction)actionCancel:(id)sender {
    [self.delegate createStepOneCancelDidPressed];
}

- (IBAction)actionNext:(id)sender {
    if (self.tokenNameTextField.text.length > 0 && self.tokenSymbolTextField.text.length > 0) {
        [self.delegate createStepOneNextDidPressedWithName:self.tokenNameTextField.text andSymbol:self.tokenSymbolTextField.text];
    } else {
        [self showAlertWithTitle:NSLocalizedString(@"Error", @"create tocken step 1") mesage:@"Please fill in all fields" andActions:nil];
    }
    NSString* str = NSLocalizedString(@"Error 2", @"create tocken step 2");
}

- (IBAction)actionVoidTap:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.tokenNameTextField]) {
        [self.tokenSymbolTextField becomeFirstResponder];
    } else if ([textField isEqual:self.tokenSymbolTextField]){
        [self actionNext:nil];
    }
    return YES;
}

@end
