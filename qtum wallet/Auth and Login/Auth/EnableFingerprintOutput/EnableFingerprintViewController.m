//
//  EnableFingerprintViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "EnableFingerprintViewController.h"

@interface EnableFingerprintViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *enableButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;

@end

@implementation EnableFingerprintViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    [self.enableButton setTitle:NSLocalizedString(@"ENABLE TOUCH ID", @"ENABLE TOUCH ID Button") forState:UIControlStateNormal];
    [self.skipButton setTitle:NSLocalizedString(@"NOT NOW", @"NOT NOW Button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Touch ID", @"Touch ID Controllers Title");
    self.infoTextLabel.text = NSLocalizedString(@"Login to QTUM \nusing Touch ID", @"");
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
