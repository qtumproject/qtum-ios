//
//  SecurityPopupViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SecurityPopupViewController.h"
#import "SecurityPinView.h"

@interface SecurityPopupViewController () <UITextFieldDelegate, CAAnimationDelegate>

@end

@implementation SecurityPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)redirectTextField:(UITextField*)textField isReversed:(BOOL) reversed {
    
    if (reversed) {
        if ([textField isEqual:self.fourthSymbolTextField]) {
            [self.thirdSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.thirdSymbolTextField]) {
            [self.secondSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.secondSymbolTextField]) {
            [self.firstSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.firstSymbolTextField]) {
            
        }
    } else {
        if ([textField isEqual:self.firstSymbolTextField]) {
            [self.secondSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.secondSymbolTextField]) {
            [self.thirdSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.thirdSymbolTextField]) {
            [self.fourthSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.fourthSymbolTextField]) {
            [self actionEnterPin:nil];
        }
    }
}

-(void)accessPinDenied {
    [self shakeAndClearText];
    [self actionIncorrectPin];
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)shakeAndClearText {
    CAKeyframeAnimation* shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.duration = 0.6;
    shake.values = @[@-20.0, @20.0, @-20.0, @20.0, @-10.0, @10.0, @-5.0, @5.0, @0.0];
    shake.delegate = self;
    [self.pinContainer.layer addAnimation:shake forKey:@"shake"];
    [self clearPinTextFields];
}

-(void)clearPinTextFields{
    self.firstSymbolTextField.text =
    self.secondSymbolTextField.text =
    self.thirdSymbolTextField.text =
    self.fourthSymbolTextField.text = @"";
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //        if ([self.delegate respondsToSelector:@selector(confilmPinFailed)]) {
        //            [self.delegate confilmPinFailed];
        //        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField isEqual:self.firstSymbolTextField]) {
        self.firstInputViewHeight.constant = 4;
    } else if ([textField isEqual:self.secondSymbolTextField]) {
        self.secondInputViewHeight.constant = 4;
    } else if ([textField isEqual:self.thirdSymbolTextField]) {
        self.thridInputViewHeight.constant = 4;
    } else if ([textField isEqual:self.fourthSymbolTextField]) {
        self.fourthInputViewHeight.constant = 4;
    }
    [self.view setNeedsLayout];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.firstSymbolTextField]) {
        self.firstInputViewHeight.constant = 2;
    } else if ([textField isEqual:self.secondSymbolTextField]) {
        self.secondInputViewHeight.constant = 2;
    } else if ([textField isEqual:self.thirdSymbolTextField]) {
        self.thridInputViewHeight.constant = 2;
    } else if ([textField isEqual:self.fourthSymbolTextField]) {
        self.fourthInputViewHeight.constant = 2;
    }
    [self.view setNeedsLayout];
}


- (BOOL)textField:(CustomTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length && [string rangeOfString:@" "].location == NSNotFound) {
        textField.realText = [string substringToIndex:1];
        textField.text = @"■";
        [self redirectTextField:textField isReversed:NO];
    }else {
        textField.text = @"";
        [self redirectTextField:textField isReversed:YES];
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Actions

- (IBAction)actionEnterPin:(id)sender {
    
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(confirmButtonPressed:withPin:)]) {
            [self.delegate confirmButtonPressed:self withPin:pin];
        }
    } else {
        [self accessPinDenied];
    }
}

#pragma mark -

-(void)actionIncorrectPin{
    [self.incorrectPinView setAlpha:0.0f];
    
    [UIView animateWithDuration:2.0f animations:^{
        [self.incorrectPinView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0f animations:^{
            [self.incorrectPinView setAlpha:0.0f];
        } completion:nil];
    }];
}

@end
