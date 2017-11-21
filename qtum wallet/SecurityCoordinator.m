//
//  SecurityCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LoginViewOutput.h"
#import "SecurityPopupViewController.h"

@interface SecurityCoordinator () <SecurityPopupViewControllerDelegate>

@property (strong, nonatomic) UIViewController *containerViewController;
@property (weak, nonatomic) id <LoginViewOutput> loginOutput;

@end

@implementation SecurityCoordinator

- (instancetype)initWithParentViewContainer:(UIViewController *) containerViewController {

	self = [super init];
	if (self) {
		_containerViewController = containerViewController;
	}
	return self;
}

- (void)start {

	if (SLocator.appSettings.isFingerprintEnabled && self.type == SendVerification) {

		[self showFingerprint];
	} else {

		[self showSecurityPopup];
	}
}

- (void)showSecurityPopup {

	SecurityPopupViewController *controller = [SLocator.popUpsManager showSecurityPopup:self presenter:nil completion:nil];
	controller.popupDelegate = self;
	self.loginOutput = controller;
}

- (void)showFingerprint {

	__weak __typeof (self) weakSelf = self;

	NSString *touchIdText = NSLocalizedString(@"Confirm Transaction", nil);

	[SLocator.touchIDService checkTouchIdWithText:touchIdText andCopmletion:^(TouchIDCompletionType type) {
		switch (type) {
			case TouchIDDenied:
				[weakSelf showSecurityPopup];
				break;
			case TouchIDSuccessed:
				[weakSelf enterUser];
				break;
			case TouchIDCanceled:
				[weakSelf cancelPin];
				break;
		}
	}];
}

#pragma mark - Private Methods

- (void)cancelPin {

	if ([self.delegate respondsToSelector:@selector (coordinatorDidCancelePassSecurity:)]) {
		[self.delegate coordinatorDidCancelePassSecurity:self];
	}

	[self hideContentController:(UIViewController *)self.loginOutput];
}


- (void)enterUser {

	if ([self.delegate respondsToSelector:@selector (coordinatorDidPassSecurity:)]) {
		[self.delegate coordinatorDidPassSecurity:self];
	}

	[self hideContentController:(UIViewController *)self.loginOutput];
}

- (void)enterPin:(NSString *) pin {

	if ([SLocator.walletManager verifyPin:pin]) {

		//in case if touchid was disabled
		if (self.type == EnableTouchIdVerification) {
			[SLocator.walletManager storePin:pin];
		}

		[self enterUser];
	} else {
		[self.loginOutput applyFailedPasswordAction];
	}
}

#pragma mark - SecurityPopupViewControllerDelegate

- (void)cancelButtonPressed:(PopUpViewController *) sender {
	[self cancelPin];
}

- (void)confirmButtonPressed:(PopUpViewController *) sender withPin:(NSString *) pin {
	[self enterPin:pin];
}

#pragma mark - Add/Remove from parent

- (void)displayContentController:(UIViewController *) content {

	[self.containerViewController addChildViewController:content];
	content.view.frame = self.containerViewController.view.frame;
	[self.containerViewController.view addSubview:content.view];
	[content didMoveToParentViewController:self.containerViewController];
}

- (void)hideContentController:(UIViewController *) content {

	[content willMoveToParentViewController:nil];
	[content.view removeFromSuperview];
	[content removeFromParentViewController];
}

@end
