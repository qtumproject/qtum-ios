//
//  EnableFingerprintViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "EnableFingerprintViewController.h"

@interface EnableFingerprintViewController ()

@end

@implementation EnableFingerprintViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)didPresseEnableAction:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didEnableFingerprint:)]) {
		[self.delegate didEnableFingerprint:YES];
	}
}

- (IBAction)didPresseCancelAction:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didCancelEnableFingerprint)]) {
		[self.delegate didCancelEnableFingerprint];
	}
}

@end
