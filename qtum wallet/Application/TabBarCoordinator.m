//
//  TabBarCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TabBarCoordinator.h"
#import "WalletCoordinator.h"
#import "NewsCoordinator.h"

@interface TabBarCoordinator ()

@property (strong,nonatomic) TabBarController* tabBarContoller;

@end

@implementation TabBarCoordinator

-(instancetype)initWithTabBarController:(TabBarController*)tabBarController{
    self = [super init];
    if (self) {
        _tabBarContoller = tabBarController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    
}

#pragma mark - TabBarCoordinatorDelegate

-(void)newsTabDidSelectedWithController:(UIViewController*)controller{
    [self checkTabsController:controller];
    NewsCoordinator* coordinator = [[NewsCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
    [coordinator start];
    [self addDependency:coordinator];
}
-(void)sendTabDidSelectedWithController:(UIViewController*)controller{
    [self checkTabsController:controller];
}
-(void)profileTabDidSelectedWithController:(UIViewController*)controller{
    [self checkTabsController:controller];
}
-(void)walletTabDidSelectedWithController:(UIViewController*)controller{
    [self checkTabsController:controller];
    WalletCoordinator* coordinator = [[WalletCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
    [coordinator start];
    [self addDependency:coordinator];
}

-(void)checkTabsController:(UIViewController*)controller{
    NSAssert([controller isKindOfClass:[UINavigationController class]], @"Tabs must be navigation");
}

@end
