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
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopy;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;

@end


@implementation ExportWalletBrandKeyViewController

@synthesize delegate, brandKey;

#pragma mark - Lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
	[self configurationBrainKeyLabel];
    [self configLocalization];
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

-(void)configLocalization {
    
    self.infoTextLabel.text = NSLocalizedString(@"You can skip this step and export your passphrase at any time", @"Skip Skip Info");
    [self.skipButton setTitle:NSLocalizedString(@"SKIP", @"Skip Button") forState:UIControlStateNormal];
    [self.buttonCopy setTitle:NSLocalizedString(@"COPY", @"Copy Button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Copy Passphrase", @"Copy Passphrase Controllers Title");
}

- (void)configurationBrainKeyLabel {

	self.brainKeyLabel.text = self.brandKey;
}

#pragma mark - Actions

- (IBAction)actionCopy:(id) sender {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.brandKey;

	[SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForBrainCodeCopied] presenter:nil completion:nil];
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
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

@end
