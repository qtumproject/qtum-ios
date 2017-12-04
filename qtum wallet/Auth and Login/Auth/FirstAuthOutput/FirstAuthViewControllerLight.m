//
//  FirstAuthViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FirstAuthViewControllerLight.h"

@interface FirstAuthViewControllerLight ()

@end

@implementation FirstAuthViewControllerLight

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configurateButtons];
}


#pragma mark - Configuration

- (void)configurateButtons {

	if (SLocator.walletManager.isSignedIn) {

		self.loginButton.hidden = NO;
		self.invitationTextLabel.text = NSLocalizedString(@"Login to QTUM \nDon't have a wallet yet?", @"");
	} else {

		self.loginButton.hidden = YES;
		self.invitationTextLabel.text = NSLocalizedString(@"You don’t have a wallet yet.", @"");
	}
}

@end
