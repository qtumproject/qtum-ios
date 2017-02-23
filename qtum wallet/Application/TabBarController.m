//
//  TabBarController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "TabBarController.h"
#import "ControllersFactory.h"
#import "NewPaymentViewController.h"

@interface TabBarController ()

@property (weak,nonatomic)NewPaymentViewController* paymentController;

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTabs];
    [self configTabBar];
}

#pragma mark - Configuration

-(void)configTabBar{
    self.tabBar.translucent = NO;
    self.tabBar.tintColor =  [UIColor colorWithRed:54/255. green:185/255. blue:200/255. alpha:1];
    self.tabBar.barTintColor = [UIColor colorWithRed:248/255. green:248/255. blue:248/255. alpha:1];
}

-(void)configTabs{
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];
    UIViewController* wallet = [[ControllersFactory sharedInstance] walletFlowTab];
    
    [self setViewControllers:@[wallet,profile,news,send] animated:YES];

    profile.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile"] tag:0];
    wallet.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Wallet" image:[UIImage imageNamed:@"history"] tag:1];
    news.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"News" image:[UIImage imageNamed:@"news"] tag:2];
    send.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Send" image:[UIImage imageNamed:@"send"] tag:3];
    
    [profile.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [wallet.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [news.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    [send.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    
    [self storeSendReference:send];
}

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount{
    self.selectedIndex = 3;
    [self.paymentController setAdress:adress andValue:amount];
}

-(void)storeSendReference:(UIViewController*)sendController{
    if ([sendController isKindOfClass:[UINavigationController class]]){
        UINavigationController* nav = (UINavigationController*)sendController;
        if ([nav.viewControllers.firstObject isKindOfClass:[NewPaymentViewController class]]){
            self.paymentController = nav.viewControllers.firstObject;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
