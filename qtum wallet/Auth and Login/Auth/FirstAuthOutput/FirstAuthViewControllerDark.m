//
//  FirstAuthViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FirstAuthViewControllerDark.h"

@interface FirstAuthViewControllerDark ()

@end

@implementation FirstAuthViewControllerDark

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configurateButtons];
}

#pragma mark - Configuration

- (void)configurateButtons {

	if (SLocator.walletManager.isSignedIn) {
		self.createButton.backgroundColor = primaryColorYellow ();
        [self.createButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
		[self.createButton setTitleColor:customBlueColor () forState:UIControlStateNormal];
		self.loginButton.hidden = NO;
        self.loginButton.backgroundColor = primaryColorYellow();
        [self.loginButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
		self.invitationTextLabel.text = NSLocalizedString(@"Login to HTMLCOIN \nDon't have a wallet yet?", @"");
	} else {
		self.createButton.backgroundColor = customRedColor ();
		[self.createButton setTitleColor:customBlackColor () forState:UIControlStateNormal];
		self.loginButton.hidden = YES;
		self.invitationTextLabel.text = NSLocalizedString(@"You don’t have a wallet yet.", @"");
	}
}

@end
