//
//  SecurityPopupViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SecurityPopupViewControllerLight.h"

@interface SecurityPopupViewControllerLight ()

@end

@implementation SecurityPopupViewControllerLight

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
@end
