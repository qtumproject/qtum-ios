//
//  ConfirmPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPopUpViewController.h"

@interface ConfirmPopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation ConfirmPopUpViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	PopUpContent *content = [self content];
	self.titleLabel.text = content.titleString;
	[self.okButton setTitle:content.okButtonTitle forState:UIControlStateNormal];
	[self.cancelButton setTitle:content.cancelButtonTitle forState:UIControlStateNormal];
}

- (IBAction)actionCancel:(id) sender {
	if ([self.delegate respondsToSelector:@selector (cancelButtonPressed:)]) {
		[self.delegate cancelButtonPressed:self];
	}
}

- (IBAction)actionOk:(id) sender {
	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}

@end
