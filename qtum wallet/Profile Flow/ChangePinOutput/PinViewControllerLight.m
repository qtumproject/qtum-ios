//
//  PinViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PinViewControllerLight.h"

@interface PinViewControllerLight ()

@end

@implementation PinViewControllerLight

- (void)configPasswordView {


	[self.passwordView setStyle:LightPopupStyle
						 lenght:SLocator.appSettings.isLongPin ? LongType : ShortType];

	self.passwordView.delegate = self;
}

- (void)keyboardWillShow:(NSNotification *) sender {

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
