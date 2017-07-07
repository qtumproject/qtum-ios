//
//  TabBarCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TabBarCoordinator.h"
#import "WalletCoordinator.h"
#import "NewsCoordinator.h"
#import "SendCoordinator.h"
#import "ProfileCoordinator.h"
#import "AppDelegate.h"

@interface TabBarCoordinator () <NewsCoordinatorDelegate, SendCoordinatorDelegate>

@property (strong,nonatomic) UITabBarController <TabbarOutput>* tabbarOutput;
@property (assign,nonatomic) BOOL walletsAlreadyStarted;
@property (assign,nonatomic) BOOL sendAlreadyStarted;
@property (assign,nonatomic) BOOL profileAlreadyStarted;
@property (assign,nonatomic) BOOL newsAlreadyStarted;

@end

@implementation TabBarCoordinator

-(instancetype)initWithTabBarController:(UITabBarController<TabbarOutput>*)tabBarController{
    self = [super init];
    if (self) {
        _tabbarOutput = tabBarController;
    }
    return self;
}

-(void)dealloc {
    
}

#pragma mark - Coordinatorable

-(void)start {
    ((AppDelegate*)[UIApplication sharedApplication].delegate).window.rootViewController = [self.tabbarOutput toPresente];
}

#pragma mark - TabBarCoordinatorDelegate

-(void)didSelecteNewsTabWithController:(UIViewController*)controller{
    
    if (!self.newsAlreadyStarted) {
        self.newsAlreadyStarted = YES;
        [self checkTabsController:controller];
        NewsCoordinator* coordinator = [[NewsCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
        [coordinator start];
        [self addDependency:coordinator];
    }
}

-(void)didSelecteSendTabWithController:(UIViewController*)controller{
    
    if (!self.sendAlreadyStarted) {
        self.sendAlreadyStarted = YES;
        SendCoordinator* coordinator = [[SendCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
        coordinator.delegate = self;
        [coordinator start];
        [self addDependency:coordinator];
        [self checkTabsController:controller];
    }
}

-(void)didSelecteProfileTabWithController:(UIViewController*)controller{
    
    if (!self.profileAlreadyStarted) {
        self.profileAlreadyStarted = YES;
        [self checkTabsController:controller];
        
        ProfileCoordinator *coordinator = [[ProfileCoordinator alloc] initWithNavigationController:(UINavigationController*)controller];
        [coordinator start];
        [self addDependency:coordinator];
    }
}

-(void)didSelecteWalletTabWithController:(UIViewController*)controller{
    
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
    [self.tabbarOutput selectSendControllerWithAdress:dict[@"publicAddress"] andValue:dict[@"amount"]];
}

-(void)showControllerByIndex:(NSInteger)index {
    
    [self.tabbarOutput setSelectedViewController:self.tabbarOutput.viewControllers[index]];
}

-(UIViewController *)getViewControllerByIndex:(NSInteger)index {
    
    return self.tabbarOutput.viewControllers[index];
}

- (void)startFromSendWithAddress:(NSString*)address andAmount:(NSString*) amount {
    [self start];
    [self.tabbarOutput selectSendControllerWithAdress:address andValue:amount];
}


#pragma mark - NewsCoordinatorDelegate

-(void)refreshTableViewData {
}

@end
