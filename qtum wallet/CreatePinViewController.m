//
//  CreatePinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "CreatePinViewController.h"
#import "CustomTextField.h"

@interface CreatePinViewController () <CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewBottomOffset;

@end

@implementation CreatePinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
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

- (IBAction)confirmButtomPressed:(id)sender {
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(didEnteredFirstTimePass:)]) {
            [self.delegate didEnteredFirstTimePass:pin];
        }
    } else {
        [self accessPinDenied];
    }
}

- (IBAction)actionCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelCreateWallet)]) {
        [self.delegate cancelCreateWallet];
    }
}

-(void)actionEnter:(id)sender{
    [self confirmButtomPressed:nil];
}



@end
