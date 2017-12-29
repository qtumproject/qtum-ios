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
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *passphraseButton;

@end

@implementation ExportBrainKeyViewController

@synthesize delegate, brandKey;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configurationBrainKeyLabel];
    [self bindToNotifications];
}

-(void)bindToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)disappearToBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    [self.passphraseButton setTitle:NSLocalizedString(@"COPY PASSPHRASE", @"COPY PASSPHRASE button") forState:UIControlStateNormal];
    self.infoTextLabel.text = NSLocalizedString(@"Copy the passphrase to restore your wallet on another device", @"");
    self.titleTextLabel.text = NSLocalizedString(@"Export Passphrase", @"Export Passphrase Controllers Title");
}

- (void)configurationBrainKeyLabel {

	self.brainKeyView.text = self.brandKey;
	[self.brainKeyView sizeToFit];
}

#pragma mark - Actions


- (IBAction)actionCopy:(id) sender {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.brandKey;

	[SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForBrainCodeCopied] presenter:nil completion:nil];
}

- (IBAction)shareButtonWasPressed:(id) sender {

	NSString *brainKey = self.brandKey;

	NSArray *sharedItems = @[brainKey];
	UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
	[self presentViewController:sharingVC animated:YES completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {

	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

- (IBAction)actionBack:(id) sender {

	[self.delegate didBackPressed];
}

@end
