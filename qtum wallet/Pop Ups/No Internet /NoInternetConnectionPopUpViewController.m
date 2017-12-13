//
//  NoInternetConnectionPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NoInternetConnectionPopUpViewController.h"

@interface NoInternetConnectionPopUpViewController ()

- (IBAction)retryButtonPressed:(UIButton *) sender;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation NoInternetConnectionPopUpViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
}

#pragma mark - Configurations

-(void)configLocalization {
    
    [self.okButton setTitle:NSLocalizedString(@"OK", @"Ok button") forState:UIControlStateNormal];
    self.infoTextLabel.text = NSLocalizedString(@"Please check your network\nsettings", @"");
    self.titleTextLabel.text = NSLocalizedString(@"No Internet Connection", @"");
}

#pragma mark - Actions

- (IBAction)retryButtonPressed:(UIButton *) sender {
	if ([self.delegate respondsToSelector:@selector (okButtonPressed:)]) {
		[self.delegate okButtonPressed:self];
	}
}
@end
