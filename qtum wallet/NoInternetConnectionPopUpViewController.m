//
//  NoInternetConnectionPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NoInternetConnectionPopUpViewController.h"

@interface NoInternetConnectionPopUpViewController ()

- (IBAction)retryButtonPressed:(UIButton *)sender;

@end

@implementation NoInternetConnectionPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)retryButtonPressed:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(okButtonPressed:)]) {
        [self.delegate okButtonPressed:self];
    }
}
@end
