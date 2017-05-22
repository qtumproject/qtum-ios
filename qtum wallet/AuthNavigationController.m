//
//  AuthNavigationController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AuthNavigationController.h"

@interface AuthNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation AuthNavigationController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
