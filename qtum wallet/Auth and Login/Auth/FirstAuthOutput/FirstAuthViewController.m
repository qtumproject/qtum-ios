//
//  FirstAuthViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FirstAuthViewController.h"

@interface FirstAuthViewController ()
@property (weak, nonatomic) IBOutlet UILabel *createNewWalletTextLabel;

@end

@implementation FirstAuthViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    [self.loginButton setTitle:NSLocalizedString(@"LOGIN", @"LOGIN Button") forState:UIControlStateNormal];
    [self.createButton setTitle:NSLocalizedString(@"CREATE NEW", @"CREATE NEW Button") forState:UIControlStateNormal];
    [self.restoreButton setTitle:NSLocalizedString(@"IMPORT WALLET", @"Resore Button") forState:UIControlStateNormal];
    self.createNewWalletTextLabel.text = NSLocalizedString(@"Create a wallet or restore a previous wallet key.", @"");
    self.invitationTextLabel.text = NSLocalizedString(@"You don’t have a wallet yet.", @"");
}

#pragma mark - Actions

- (IBAction)createNewButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (didCreateNewButtonPressed)]) {
		[self.delegate didCreateNewButtonPressed];
	}
}

- (IBAction)restoreButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (didRestoreButtonPressed)]) {
		[self.delegate didRestoreButtonPressed];
	}
}

- (IBAction)loginButtonWasPressed:(id) sender {
	if ([self.delegate respondsToSelector:@selector (didLoginPressed)]) {
		[self.delegate didLoginPressed];
	}
}

@end
