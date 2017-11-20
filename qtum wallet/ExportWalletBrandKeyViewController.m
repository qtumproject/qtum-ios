//
//  ExportWalletBrandKeyViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ExportWalletBrandKeyViewController.h"
#import "BorderedLabel.h"

@interface ExportWalletBrandKeyViewController () <PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet BorderedLabel *brainKeyLabel;

@end


@implementation ExportWalletBrandKeyViewController

@synthesize delegate, brandKey;

- (void)viewDidLoad {

	[super viewDidLoad];
	[self configurationBrainKeyLabel];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

- (NSString *)stringForLabelWithArrayWords:(NSArray *) array {

	NSString *resultSting;
	for (id item in array) {
		resultSting = resultSting ? [NSString stringWithFormat:@"%@ %@", resultSting, item] : [NSString stringWithFormat:@"%@", item];
	}
	return resultSting;
}

#pragma mark - Configuration

- (void)configurationBrainKeyLabel {

	self.brainKeyLabel.text = self.brandKey;
}

#pragma mark - Actions

- (IBAction)actionCopy:(id) sender {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.brandKey;

	[[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForBrainCodeCopied] presenter:nil completion:nil];
}

- (IBAction)actionContinue:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didExportWalletPressed)]) {
		[self.delegate didExportWalletPressed];
	}
}

- (IBAction)shareButtonWasPressed:(id) sender {

	NSString *brandKeyString = self.brandKey;
	NSArray *sharedItems = @[brandKeyString];
	UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
	[self presentViewController:sharingVC animated:YES completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {
	[[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
