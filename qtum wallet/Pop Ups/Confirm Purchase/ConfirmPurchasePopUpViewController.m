//
//  ConfirmPurchasePopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPurchasePopUpViewController.h"

@interface ConfirmPurchasePopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractNameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractTypeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *minerAddressTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeTextLabel;

@end

@implementation ConfirmPurchasePopUpViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Confirm Purchase", @"");
    self.contractNameTextLabel.text = NSLocalizedString(@"Contract Name:", @"");
    self.contractNameTextLabel.text = NSLocalizedString(@"Contract Type:", @"");
    self.priceTextLabel.text = NSLocalizedString(@"Price:", @"");
    self.minerAddressTextLabel.text = NSLocalizedString(@"Miner Address:", @"");
    self.feeTextLabel.text = NSLocalizedString(@"Fee:", @"");
}

#pragma mark - Actions

- (IBAction)actionCancel:(id) sender {
	if ([self.delegate respondsToSelector:@selector (cancelButtonPressed:)]) {
		[self.delegate cancelButtonPressed:self];
	}
}

- (IBAction)actionConfirm:(id) sender {
	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}

@end
