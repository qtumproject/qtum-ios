//
//  NewsNavigationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "NewsNavigationController.h"

@interface NewsNavigationController ()

@end

@implementation NewsNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return [AppSettings sharedInstance].isDarkTheme ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

@end
