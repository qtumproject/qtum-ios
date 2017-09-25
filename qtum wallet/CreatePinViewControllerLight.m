//
//  CreatePinViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "CreatePinViewControllerLight.h"

@interface CreatePinViewControllerLight ()

@end

@implementation CreatePinViewControllerLight

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

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.gradientViewBottomOffset.constant = end.size.height + 20;
    [self.view layoutIfNeeded];
}

@end
