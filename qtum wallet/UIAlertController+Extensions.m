//
//  UIAlertController+Extensions.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "UIAlertController+Extensions.h"

@implementation UIAlertController (Extensions)

+ (UIAlertController *)warningMessageWithSettingsButtonAndTitle:(NSString *) title message:(NSString *) text withActionHandler:(ActionHandler) completion {
	UIAlertController *controller = [UIAlertController alertControllerWithTitle:title
																		message:text
																 preferredStyle:UIAlertControllerStyleAlert];



	UIAlertAction *settingsAction = [UIAlertAction
			actionWithTitle:@"Settings"
					  style:UIAlertActionStyleCancel
					handler:^(UIAlertAction *_Nonnull action) {
						[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
					}];

	UIAlertAction *approveAction = [UIAlertAction
			actionWithTitle:@"Cancel"
					  style:UIAlertActionStyleDefault
					handler:completion];

	[controller addAction:settingsAction];
	[controller addAction:approveAction];

	return controller;
}

@end
