//
//  TabBarControllerLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TabBarControllerLight.h"

@interface TabBarControllerLight ()

@end

@implementation TabBarControllerLight

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
    
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];
    UIViewController* wallet = [[ControllersFactory sharedInstance] walletFlowTab];
    
    [self setViewControllers:@[wallet,profile,news,send] animated:YES];
    
    profile.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", "Tabs") image:[UIImage imageNamed:@"profile"] tag:0];
    wallet.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Wallet", "Tabs") image:[UIImage imageNamed:@"history"] tag:1];
    news.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"News", "Tabs") image:[UIImage imageNamed:@"news"] tag:2];
    send.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Send", "Tabs") image:[UIImage imageNamed:@"send"] tag:3];
    
    [profile.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [wallet.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [news.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [send.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [self storeSendReference:send];
}

#pragma mark TabbarOutput

-(void)setControllerForNews:(UIViewController*)newsController
                    forSend:(UIViewController*)sendController
                  forWallet:(UIViewController*)walletController
                 forProfile:(UIViewController*)profileController {
    
    [self configTabsWithNews:newsController send:sendController wallet:walletController profile:profileController];
}


@end
