//
//  FirstAuthViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "FirstAuthViewControllerDark.h"

@interface FirstAuthViewControllerDark ()

@end

@implementation FirstAuthViewControllerDark

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurateButtons];
}

#pragma mark - Configuration

-(void)configurateButtons {
    
    if ([ApplicationCoordinator sharedInstance].walletManager.isSignedIn) {
        self.createButton.backgroundColor = [UIColor clearColor];
        [self.createButton setTitleColor:customBlueColor() forState:UIControlStateNormal];
        self.loginButton.hidden = NO;
        self.invitationTextLabel.text = NSLocalizedString(@"Login to QTUM \nDon't have a wallet yet?", @"");
    } else {
        self.createButton.backgroundColor = customRedColor();
        [self.createButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
        self.loginButton.hidden = YES;
        self.invitationTextLabel.text = NSLocalizedString(@"You don’t have a wallet yet.", @"");
    }
}

@end
