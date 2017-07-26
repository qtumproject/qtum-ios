//
//  PinViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinViewControllerLight.h"

@interface PinViewControllerLight ()

@end

@implementation PinViewControllerLight


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField isEqual:self.firstSymbolTextField]) {
        
        self.firstInputViewHeight.constant *= 2;
        self.firstInputUnderlineView.backgroundColor = textFieldLineColorSelected();
        
    } else if ([textField isEqual:self.secondSymbolTextField]) {
        
        self.secondInputViewHeight.constant *= 2;
        self.secondInputUnderlineView.backgroundColor = textFieldLineColorSelected();

    } else if ([textField isEqual:self.thirdSymbolTextField]) {
        
        self.thridInputViewHeight.constant *= 2;
        self.thridInputUnderlineView.backgroundColor = textFieldLineColorSelected();
    } else if ([textField isEqual:self.fourthSymbolTextField]) {
        
        self.fourthInputViewHeight.constant *= 2;
        self.fourthInputUnderlineView.backgroundColor = textFieldLineColorSelected();
    }
    [self.view setNeedsLayout];
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.firstSymbolTextField]) {
        self.firstInputViewHeight.constant /= 2;
        self.firstInputUnderlineView.backgroundColor = lightTextFieldLineDeselected();
    } else if ([textField isEqual:self.secondSymbolTextField]) {
        
        self.secondInputUnderlineView.backgroundColor = lightTextFieldLineDeselected();
        self.secondInputViewHeight.constant /= 2;
    } else if ([textField isEqual:self.thirdSymbolTextField]) {
        
        self.thridInputUnderlineView.backgroundColor = lightTextFieldLineDeselected();
        self.thridInputViewHeight.constant /= 2;
    } else if ([textField isEqual:self.fourthSymbolTextField]) {
        
        self.fourthInputUnderlineView.backgroundColor = lightTextFieldLineDeselected();
        self.fourthInputViewHeight.constant /= 2;
    }
    
    [self.view setNeedsLayout];
}

- (BOOL)textField:(CustomTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length && [string rangeOfString:@" "].location == NSNotFound) {
        textField.realText = [string substringToIndex:1];
        textField.text = @"•";
        [self redirectTextField:textField isReversed:NO];
    }else {
        textField.text = @"";
        [self redirectTextField:textField isReversed:YES];
    }
    return NO;
}

-(void)keyboardWillHide:(NSNotification *)sender {
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomForButtonsConstraint.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    CGFloat tapBarHeight = 0.0f;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tapBarVC = (UITabBarController *)vc;
        tapBarHeight = tapBarVC.tabBar.frame.size.height;
    }
    
    self.bottomForButtonsConstraint.constant = end.size.height - tapBarHeight + 20;
    [self.view layoutIfNeeded];
}

@end
