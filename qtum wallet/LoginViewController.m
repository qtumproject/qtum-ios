//
//  LoginViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCoordinator.h"

@interface LoginViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewBottomOffset;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    self.gradientViewBottomOffset.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions


- (IBAction)actionEnterPin:(id)sender {
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.text,self.secondSymbolTextField.text,self.thirdSymbolTextField.text,self.fourthSymbolTextField.text];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(passwordDidEntered:)]) {
            [self.delegate passwordDidEntered:pin];
        }
    } else {
        [self applyFailedPasswordAction];
    }
}

- (IBAction)actionCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmPasswordDidCanceled)]) {
        [self.delegate confirmPasswordDidCanceled];
    }
}

-(void)applyFailedPasswordAction{
    [self accessPinDenied];
    [self clearPinTextFields];
    [self.firstSymbolTextField becomeFirstResponder];
}

@end
