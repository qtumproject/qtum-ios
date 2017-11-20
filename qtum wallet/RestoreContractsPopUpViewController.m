//
//  RestoreContractsPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RestoreContractsPopUpViewController.h"

@interface RestoreContractsPopUpViewController ()

@end

@implementation RestoreContractsPopUpViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)setContent:(PopUpContent *) content {
	DLog(@"Pop-up not for content!!!");
}

- (IBAction)backAction:(id) sender {
	if ([self.delegate respondsToSelector:@selector (cancelButtonPressed:)]) {
		[self.delegate cancelButtonPressed:self];
	}
}

- (IBAction)restoreAction:(id) sender {
	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}

@end
