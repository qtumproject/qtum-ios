//
//  WalletNameViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletNameViewControllerLight.h"

@interface WalletNameViewControllerLight ()

@end

@implementation WalletNameViewControllerLight

- (void)keyboardWillShow:(NSNotification *) sender {

	CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
	self.buttonsBottomConstraint.constant = end.size.height + 20;
	[self.view layoutIfNeeded];
}

@end
