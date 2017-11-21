//
//  ExportBrainKeyViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "ExportBrainKeyViewController.h"

@interface ExportBrainKeyViewController () <PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *brainKeyView;

@end

@implementation ExportBrainKeyViewController

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

	self.brainKeyView.text = self.brandKey;
	[self.brainKeyView sizeToFit];
}

#pragma mark - Actions


- (IBAction)actionCopy:(id) sender {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.brandKey;

	[SLocator.popUpsManager showInformationPopUp:self withContent:[PopUpContentGenerator contentForBrainCodeCopied] presenter:nil completion:nil];
}

- (IBAction)shareButtonWasPressed:(id) sender {

	NSString *brainKey = self.brandKey;

	NSArray *sharedItems = @[brainKey];
	UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
	[self presentViewController:sharingVC animated:YES completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {

	[SLocator.popUpsManager hideCurrentPopUp:YES completion:nil];
}

- (IBAction)actionBack:(id) sender {

	[self.delegate didBackPressed];
}

@end
