//
//  TabBarControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
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

- (void)configTabBar {

	self.tabBar.translucent = NO;
	self.tabBar.tintColor = lightDarkGrayColor ();
	self.tabBar.barTintColor = lightBlueColor ();
}

- (void)configTabsWithNews:(UIViewController *) newsController
					  send:(UIViewController *) sendController
					wallet:(UIViewController *) walletController
				   profile:(UIViewController *) profileController {

	UIViewController *news = [SLocator.controllersFactory newsFlowTab];
	UIViewController *send = [SLocator.controllersFactory sendFlowTab];
	UIViewController *profile = [SLocator.controllersFactory profileFlowTab];
	UIViewController *wallet = [SLocator.controllersFactory walletFlowTab];

	[self setViewControllers:@[wallet, profile, news, send] animated:YES];

	profile.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Profile", "Tabs") image:[UIImage imageNamed:@"ic-profile-light"] tag:0];
	wallet.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Wallet", "Tabs") image:[UIImage imageNamed:@"ic-wallet-light"] tag:1];
	news.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"News", "Tabs") image:[UIImage imageNamed:@"ic-news-light"] tag:2];
	send.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Send", "Tabs") image:[UIImage imageNamed:@"ic-send-light"] tag:3];

	[profile.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[wallet.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[news.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
	[send.tabBarItem setTitlePositionAdjustment:UIOffsetMake (0, -3)];
}

#pragma mark TabbarOutput

- (void)setControllerForNews:(UIViewController *) newsController
					 forSend:(UIViewController *) sendController
				   forWallet:(UIViewController *) walletController
				  forProfile:(UIViewController *) profileController {

	[self configTabsWithNews:newsController send:sendController wallet:walletController profile:profileController];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


@end
