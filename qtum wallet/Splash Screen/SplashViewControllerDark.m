//
//  SplashViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SplashViewControllerDark.h"
#import "AnimatedLogoImageVIew.h"

@interface SplashViewControllerDark ()

@property (weak, nonatomic) IBOutlet AnimatedLogoImageVIew *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation SplashViewControllerDark

#pragma mark - Lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];

	self.titleLabel.alpha = 0.0f;
	self.textLabel.alpha = 0.0f;
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    self.textLabel.text = NSLocalizedString(@"Please wait", @"");
}

- (UIStatusBarStyle)preferredStatusBarStyle {

	return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL) animated {

	[super viewDidAppear:animated];

	[UIView animateWithDuration:1.0f animations:^{
		self.titleLabel.alpha = 1.0f;
		self.textLabel.alpha = 1.0f;
	}                completion:^(BOOL finished) {
		[self.logoImageView startAnimating];
	}];
}

- (void)viewWillDisappear:(BOOL) animated {

	[super viewWillDisappear:animated];

	[self.logoImageView stopAnimating];
}

@end
