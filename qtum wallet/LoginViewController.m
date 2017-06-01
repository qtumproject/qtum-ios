//
//  LoginViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginCoordinator.h"

@interface LoginViewController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewBottomOffset;
@property (assign, nonatomic) BOOL shoudKeboardDismiss;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    //when comes from imessage have problems with keyboard dissmisng
    if (!self.shoudKeboardDismiss) {
        [self.firstSymbolTextField becomeFirstResponder];
    }
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions

- (IBAction)actionEnterPin:(id)sender {
    self.shoudKeboardDismiss = YES;
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(passwordDidEntered:)]) {
            [self.delegate passwordDidEntered:pin];
        }
    } else {
        [self applyFailedPasswordAction];
    }
}

- (IBAction)actionCancel:(id)sender {
    self.shoudKeboardDismiss = YES;
    if ([self.delegate respondsToSelector:@selector(confirmPasswordDidCanceled)]) {
        [self.delegate confirmPasswordDidCanceled];
    }
}

-(void)actionEnter:(id)sender{
    [self actionEnterPin:nil];
}

-(void)applyFailedPasswordAction{
    [self accessPinDenied];
    [self clearPinTextFields];
    [self.firstSymbolTextField becomeFirstResponder];
}

@end
