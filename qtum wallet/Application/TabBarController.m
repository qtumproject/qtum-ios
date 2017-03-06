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
#import "TabBarCoordinator.h"

@interface TabBarController () <UITabBarControllerDelegate>

@property (weak,nonatomic)NewPaymentViewController* paymentController;

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
    if ([self.customizableViewControllers.firstObject isKindOfClass:[UINavigationController class]]) {
        [self.coordinatorDelegate walletTabDidSelectedWithController:self.customizableViewControllers.firstObject];
    }
}

#pragma mark - Configuration

-(void)configTabBar{
    self.tabBar.translucent = NO;
    self.tabBar.tintColor =  [UIColor colorWithRed:54/255. green:185/255. blue:200/255. alpha:1];
    self.tabBar.barTintColor = [UIColor colorWithRed:248/255. green:248/255. blue:248/255. alpha:1];
}

-(void)configTabs{
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];//[UINavigationController new];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];//[UINavigationController new];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];//[UINavigationController new];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (self.selectedIndex == 0) {
        [self.coordinatorDelegate walletTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 1){
        //[self.coordinatorDelegate profileTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 2){
        //[self.coordinatorDelegate newsTabDidSelectedWithController:viewController];
    }else if (self.selectedIndex == 3){
        //[self.coordinatorDelegate sendTabDidSelectedWithController:viewController];
    }
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
