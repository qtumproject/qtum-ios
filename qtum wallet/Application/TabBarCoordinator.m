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
@property (assign,nonatomic) BOOL walletsAlreadyStarted;
@property (assign,nonatomic) BOOL sendAlreadyStarted;
@property (assign,nonatomic) BOOL profileAlreadyStarted;
@property (assign,nonatomic) BOOL newsAlreadyStarted;


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
    
    if (!self.newsAlreadyStarted) {
        self.newsAlreadyStarted = YES;
        [self checkTabsController:controller];
        NewsCoordinator* coordinator = [[NewsCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
        [coordinator start];
        [self addDependency:coordinator];
    }
}
-(void)sendTabDidSelectedWithController:(UIViewController*)controller{
    
    if (!self.sendAlreadyStarted) {
        self.sendAlreadyStarted = YES;
        [self checkTabsController:controller];
    }
}
-(void)profileTabDidSelectedWithController:(UIViewController*)controller{
    
    if (!self.profileAlreadyStarted) {
        self.profileAlreadyStarted = YES;
        [self checkTabsController:controller];
    }
}
-(void)walletTabDidSelectedWithController:(UIViewController*)controller{
    
    if (!self.walletsAlreadyStarted) {
        self.walletsAlreadyStarted = YES;
        [self checkTabsController:controller];
        WalletCoordinator* coordinator = [[WalletCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
        coordinator.delegate = self;
        [coordinator start];
        [self addDependency:coordinator];
    }
}

-(void)checkTabsController:(UIViewController*)controller{
    NSAssert([controller isKindOfClass:[UINavigationController class]], @"Tabs must be navigation");
}

-(void)createPaymentFromWalletScanWithDict:(NSDictionary*) dict{
    [self.tabBarContoller selectSendControllerWithAdress:dict[@"publicAddress"] andValue:dict[@"amount"]];
}

-(void)showControllerByIndex:(NSInteger)index{
    [self.tabBarContoller setSelectedViewController:[self.tabBarContoller.viewControllers objectAtIndex:index]];
}

-(UIViewController *)getViewControllerByIndex:(NSInteger)index{
    return [self.tabBarContoller.viewControllers objectAtIndex:index];;
}

@end
