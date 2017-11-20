//
//  ConfirmPurchasePopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPurchasePopUpViewController.h"

@interface ConfirmPurchasePopUpViewController ()

@end

@implementation ConfirmPurchasePopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)actionCancel:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelButtonPressed:)]) {
        [self.delegate cancelButtonPressed:self];
    }
}

- (IBAction)actionConfirm:(id)sender {
    if ([self.delegate respondsToSelector:@selector(okButtonPressed:)]) {
        [self.delegate okButtonPressed:self];
    }
}

@end
