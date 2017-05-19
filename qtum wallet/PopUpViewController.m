//
//  PopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "PopUpViewController.h"

@interface PopUpViewController ()

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (controller == nil) return;
    
    [controller presentViewController:self animated:animated completion:completion];
}

- (void)hide:(BOOL)animated completion:(void (^)(void))completion
{
    [self dismissViewControllerAnimated:animated completion:completion];
}

@end
