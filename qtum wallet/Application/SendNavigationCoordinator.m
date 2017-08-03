//
//  SendNavigationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "SendNavigationCoordinator.h"

@interface SendNavigationCoordinator ()

@end

@implementation SendNavigationCoordinator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return [AppSettings sharedInstance].isDarkTheme ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
}

@end
