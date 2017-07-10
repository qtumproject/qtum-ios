//
//  FirstAuthViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "FirstAuthViewController.h"

@interface FirstAuthViewController ()

@end

@implementation FirstAuthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)createNewButtonWasPressed:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didCreateNewButtonPressed)]) {
        [self.delegate didCreateNewButtonPressed];
    }
}

- (IBAction)restoreButtonWasPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didRestoreButtonPressed)]) {
        [self.delegate didRestoreButtonPressed];
    }
}

- (IBAction)loginButtonWasPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didLoginPressed)]) {
        [self.delegate didLoginPressed];
    }
}

@end
