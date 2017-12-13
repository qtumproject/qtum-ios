//
//  ShareTokenPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ShareTokenPopUpViewController.h"

@interface ShareTokenPopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractAddressTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *abiInterfaceTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *abiCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation ShareTokenPopUpViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
    [self configLocalization];
}

- (void)viewWillAppear:(BOOL) animated {

	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];

	[self.addressLabel setText:self.addressString];
	[self.abiTextView setText:self.abiString];

	[self.abiTextView setContentOffset:CGPointZero];
	NSLog (@"%@", self.abiTextView);
}

#pragma mark - Configuration

-(void)configLocalization {
 
    self.titleTextLabel.text = NSLocalizedString(@"Copy to Share", @"");
    self.contractAddressTextLabel.text = NSLocalizedString(@"Contract Address", @"");
    self.abiInterfaceTextLabel.text = NSLocalizedString(@"ABI Interface", @"");
    
    [self.abiCopyButton setTitle:NSLocalizedString(@"COPY ABI", @"COPY ABI button") forState:UIControlStateNormal];
    [self.addressCopyButton setTitle:NSLocalizedString(@"COPY ADDRESS", @"COPY ADDRESS button") forState:UIControlStateNormal];
    [self.okButton setTitle:NSLocalizedString(@"OK", @"Ok button") forState:UIControlStateNormal];
}

#pragma mark - Actions

- (IBAction)actionCopyAddress:(id) sender {

	if ([self.delegate respondsToSelector:@selector (copyAddressButtonPressed:)]) {
		[self.delegate copyAddressButtonPressed:self];
	}
}

- (IBAction)actionCopyAbi:(id) sender {

	if ([self.delegate respondsToSelector:@selector (copyAbiButtonPressed:)]) {
		[self.delegate copyAbiButtonPressed:self];
	}
}

- (IBAction)actionOk:(id) sender {

	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}

@end
