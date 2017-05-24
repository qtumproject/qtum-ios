//
//  HistoryNavigationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "WalletNavigationController.h"

@interface WalletNavigationController ()

@end

@implementation WalletNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
