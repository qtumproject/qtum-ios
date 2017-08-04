//
//  SplashViewControllerDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 04.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SplashViewControllerDark.h"
#import "AnimatedLogoImageVIew.h"

@interface SplashViewControllerDark ()

@property (weak, nonatomic) IBOutlet AnimatedLogoImageVIew *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation SplashViewControllerDark

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.alpha = 0.0f;
    self.textLabel.alpha = 0.0f;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:1.0f animations:^{
        self.titleLabel.alpha = 1.0f;
        self.textLabel.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.logoImageView startAnimating];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.logoImageView stopAnimating];
}

@end
