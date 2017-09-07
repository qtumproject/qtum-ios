//
//  RepeateViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "RepeateViewController.h"

@interface RepeateViewController ()

@end

@implementation RepeateViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender{
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender {
    
    self.gradientViewBottomOffset.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions


- (IBAction)actionEnterPin:(id)sender {
    
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(didEnteredSecondPin:)]) {
            [self.delegate didEnteredSecondPin:pin];
        }
    } else {
        [self accessPinDenied];
    }
}

- (IBAction)actionCancel:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didCancelPressedOnRepeatePin)]) {
        [self.delegate didCancelPressedOnRepeatePin];
    }
}

-(void)actionEnter:(id)sender {
    
    [self actionEnterPin:nil];
}

#pragma mark - Public Methods

-(void)startCreateWallet{

}

-(void)endCreateWalletWithError:(NSError*)error {
    
    if (error) {
        if ([self.delegate respondsToSelector:@selector(didCancelPressedOnRepeatePin)]) {
            [self.delegate didCancelPressedOnRepeatePin];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(didCreateWalletPressed)]) {
            [self.delegate didCreateWalletPressed];
        }
    }
}

-(void)showFailedStatus {
    
    [self accessPinDenied];
}


@end
