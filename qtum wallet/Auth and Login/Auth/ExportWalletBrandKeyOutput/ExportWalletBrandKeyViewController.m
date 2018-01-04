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
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopy;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (strong, nonatomic) NSString *brandKeyString;

@end


@implementation ExportWalletBrandKeyViewController

@synthesize delegate, brandKey;

#pragma mark - Lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
	[self configurationBrainKeyLabel];
    [self configLocalization];
    [self bindToNotifications];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)bindToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearToBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)disappearToBackground {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Accessors

-(void)setBrandKey:(NSArray<NSString *> *)brandKey {
    
    NSMutableString* brandKeyString = [NSMutableString new];
    
    for (int i = 0; i < brandKey.count; i++) {
        
        if (i != 0) {
            [brandKeyString appendString:@" "];
        }
        [brandKeyString appendString:brandKey[i]];
    }
    
    self.brandKeyString = [brandKeyString copy];
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
    [self.continueButton  setTitle:NSLocalizedString(@"CONTINUE", @"CONTINUE Button") forState:UIControlStateNormal];
    [self.buttonCopy setTitle:NSLocalizedString(@"COPY", @"Copy Button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Copy Passphrase", @"Copy Passphrase Controllers Title");
}

- (void)configurationBrainKeyLabel {

	self.brainKeyLabel.text = self.brandKeyString;
}

#pragma mark - Actions

- (IBAction)actionCopy:(id) sender {

	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = self.brandKeyString;

	[SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForBrainCodeCopied] presenter:nil completion:nil];
}

- (IBAction)actionContinue:(id) sender {

	if ([self.delegate respondsToSelector:@selector (didContinueRepeateBrandKey)]) {
		[self.delegate didContinueRepeateBrandKey];
	}
}

- (IBAction)shareButtonWasPressed:(id) sender {

	NSString *brandKeyString = self.brandKeyString;
	NSArray *sharedItems = @[brandKeyString];
	UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
	[self presentViewController:sharingVC animated:YES completion:nil];
}

- (IBAction)actionBackPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didExitPressed)]) {
        [self.delegate didExitPressed];
    }
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

@end
