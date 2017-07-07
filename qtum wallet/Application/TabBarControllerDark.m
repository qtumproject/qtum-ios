//
//  TabBarControllerDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TabBarControllerDark.h"

@interface TabBarControllerDark ()

@end

@implementation TabBarControllerDark

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTabBar];
}

#pragma mark - Configuration

-(void)configTabBar {
    
    self.tabBar.translucent = NO;
    self.tabBar.tintColor =  customBlueColor();
    self.tabBar.barTintColor = customBlackColor();
}

-(void)configTabsWithNews:(UIViewController*)newsController
                     send:(UIViewController*)sendController
                   wallet:(UIViewController*)walletController
                  profile:(UIViewController*)profileController {
    
    [self setViewControllers:@[profileController,walletController,newsController,sendController] animated:YES];
    
    profileController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", "Tabs") image:[UIImage imageNamed:@"profile"] tag:0];
    walletController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Wallet", "Tabs") image:[UIImage imageNamed:@"history"] tag:1];
    newsController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"News", "Tabs") image:[UIImage imageNamed:@"news"] tag:2];
    sendController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Send", "Tabs") image:[UIImage imageNamed:@"send"] tag:3];
    
    [profileController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [walletController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [newsController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [sendController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [self storeSendReference:profileController];
}

#pragma mark TabbarOutput

-(void)setControllerForNews:(UIViewController*)newsController
                    forSend:(UIViewController*)sendController
                  forWallet:(UIViewController*)walletController
                 forProfile:(UIViewController*)profileController {
    
    [self configTabsWithNews:newsController send:sendController wallet:walletController profile:profileController];
}


@end
