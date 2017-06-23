//
//  FirstAuthViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "FirstAuthViewController.h"

@interface FirstAuthViewController ()

@property (weak, nonatomic) IBOutlet UIButton *createButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomButtonsOffset;

- (IBAction)createNewButtonWasPressed:(id)sender;

@end

@implementation FirstAuthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurateButtons];
}

#pragma mark - Configuration

-(void)configurateButtons {
    
    if ([[WalletManager sharedInstance] haveWallets] && [WalletManager sharedInstance].PIN) {
        self.createButton.backgroundColor = [UIColor clearColor];
        [self.createButton setTitleColor:customBlueColor() forState:UIControlStateNormal];
        self.loginButton.hidden = NO;
    } else {
        self.createButton.backgroundColor = customRedColor();
        [self.createButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
        self.loginButton.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)createNewButtonWasPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(createNewButtonPressed)]) {
        [self.delegate createNewButtonPressed];
    }
}

- (IBAction)restoreButtonWasPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(restoreButtonPressed)]) {
        [self.delegate restoreButtonPressed];
    }
}

- (IBAction)loginButtonWasPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(restoreButtonPressed)]) {
        [self.delegate didLoginPressed];
    }
}

@end
