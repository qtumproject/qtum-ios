//
//  TabBarController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "TabBarController.h"
#import "ControllersFactory.h"
#import "NewPaymentDarkViewController.h"
#import "TabBarCoordinator.h"

@interface TabBarController () <UITabBarControllerDelegate>

@property (weak,nonatomic)NewPaymentDarkViewController* paymentController;

@end

@implementation TabBarController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self configTabs];
    [self configTabBar];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //select controller
    if ([self.customizableViewControllers.firstObject isKindOfClass:[UINavigationController class]] && !self.isReload) {
        [self.coordinatorDelegate walletTabDidSelectedWithController:self.customizableViewControllers.firstObject];
    }
}

#pragma mark - Configuration

-(void)configTabBar{
    self.tabBar.translucent = NO;
    self.tabBar.tintColor =  customBlueColor();
    self.tabBar.barTintColor = customBlackColor();
}

-(void)configTabs {
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];//[UINavigationController new];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];//[UINavigationController new];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];//[UINavigationController new];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.selectedIndex == 0) {
        [self.coordinatorDelegate walletTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 1){
        //[self.coordinatorDelegate profileTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 2){
        [self.coordinatorDelegate newsTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 3){
        [self.coordinatorDelegate sendTabDidSelectedWithController:viewController];
    }
}

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount{
    self.selectedIndex = 3;
    [self.paymentController setAdress:adress andValue:amount];
}

-(void)storeSendReference:(UIViewController*)sendController{
    if ([sendController isKindOfClass:[UINavigationController class]]){
        UINavigationController* nav = (UINavigationController*)sendController;
        if ([nav.viewControllers.firstObject isKindOfClass:[NewPaymentDarkViewController class]]){
            self.paymentController = nav.viewControllers.firstObject;
        }
    }
}



@end
