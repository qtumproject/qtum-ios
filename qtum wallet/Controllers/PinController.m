//
//  CreatePinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "PinController.h"

@interface PinController () <CAAnimationDelegate>

@end

@implementation PinController

- (void)viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardDidShow:)
												 name:UIKeyboardDidShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (applicationWillEnterForeground)
												 name:UIApplicationWillEnterForegroundNotification
											   object:nil];
	self.editingEnabled = NO;
}

- (void)viewDidAppear:(BOOL) animated {

	self.editingEnabled = YES;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *) sender {
	[self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *) sender {
	[self.view layoutIfNeeded];
}

- (void)applicationWillEnterForeground {
	[self.view layoutIfNeeded];
}

- (void)keyboardDidShow:(NSNotification *) sender {
	//need to be overrided
}

@end
