//
//  ConfirmPinForExportViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPinForExportViewControllerLight.h"

@interface ConfirmPinForExportViewControllerLight ()

@end

@implementation ConfirmPinForExportViewControllerLight


-(void)configPasswordView {
    
    [self.passwordView setStyle:LightStyle lenght:YES ? ShortType : LongType];
    self.passwordView.delegate = self;
}

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomConstraintForCancelButton.constant = end.size.height + 20;
    [self.view layoutIfNeeded];
}

@end
