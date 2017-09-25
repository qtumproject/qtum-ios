//
//  CreatePinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "CreatePinViewController.h"
#import "CustomTextField.h"

@interface CreatePinViewController () <CAAnimationDelegate>

@property (assign, nonatomic, getter = isProcessing) BOOL processing;

@end

@implementation CreatePinViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions

- (IBAction)confirmButtomPressed:(id)sender {
    
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        [self.view endEditing:YES];
        if ([self.delegate respondsToSelector:@selector(didEntererFirstPin:)]) {
            [self.delegate didEntererFirstPin:pin];
        }
    } else {
        [self accessPinDenied];
    }
}

- (IBAction)actionCancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didCancelPressedOnCreateWallet)]) {
        [self.delegate didCancelPressedOnCreateWallet];
    }
}

-(void)actionEnter:(id)sender {
    
    if (!self.isProcessing) {
        [self confirmButtomPressed:nil];
    }
}

@end
