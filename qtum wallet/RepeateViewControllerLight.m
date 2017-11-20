//
//  RepeateViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RepeateViewControllerLight.h"

@interface RepeateViewControllerLight ()

@end

@implementation RepeateViewControllerLight

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.gradientViewBottomOffset.constant = end.size.height + 20;
	[self.view layoutIfNeeded];
}

- (void)configPasswordView {

	[self.passwordView setStyle:LightStyle lenght:LongType];
	self.passwordView.delegate = self;
}

@end
