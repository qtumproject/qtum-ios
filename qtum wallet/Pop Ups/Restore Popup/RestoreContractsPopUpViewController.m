//
//  RestoreContractsPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RestoreContractsPopUpViewController.h"

@interface RestoreContractsPopUpViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *backupDateTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *backupVersionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractsTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokensTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *temlatesTextLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

@end

@implementation RestoreContractsPopUpViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Restore Contracts", @"");
    self.backupDateTextLabel.text = NSLocalizedString(@"Backup Date", @"");
    self.backupVersionTextLabel.text = NSLocalizedString(@"Backup App Version", @"");
    self.contractsTextLabel.text = NSLocalizedString(@"Contracts", @"");
    self.tokensTextLabel.text = NSLocalizedString(@"Tokens", @"");
    self.temlatesTextLabel.text = NSLocalizedString(@"Templates", @"");
    
    [self.backButton setTitle:NSLocalizedString(@"BACK", @"BACK button") forState:UIControlStateNormal];
    [self.restoreButton setTitle:NSLocalizedString(@"RESTORE", @"RESTORE button") forState:UIControlStateNormal];
}

- (void)setContent:(PopUpContent *) content {
	DLog(@"Pop-up not for content!!!");
}

#pragma mark - Actions

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
