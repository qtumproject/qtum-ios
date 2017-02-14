//
//  ControllersFactory.m
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ControllersFactory.h"
#import "SendNavigationCoordinator.h"
#import "NewsNavigationCoordinator.h"
#import "WalletNavigationCoordinator.h"
#import "ProfileNavigationCoordinator.h"
#import "UIViewController+Extension.h"
#import "StartNavigationCoordinator.h"
#import "TabBarController.h"

@implementation ControllersFactory

+ (instancetype)sharedInstance
{
    static ControllersFactory *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) { }
    return self;
}

-(UIViewController*)sendFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Send" withIdentifire:nil];
    SendNavigationCoordinator* nav = [[SendNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)profileFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Profile" withIdentifire:nil];
    ProfileNavigationCoordinator* nav = [[ProfileNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)newsFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"News" withIdentifire:nil];
    NewsNavigationCoordinator* nav = [[NewsNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createTabFlow{
    TabBarController* tabBar = [TabBarController new];
    return tabBar;
}



-(UIViewController*)walletFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Wallet" withIdentifire:nil];
    WalletNavigationCoordinator* nav = [[WalletNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createFlowNavigationCoordinator{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Start" withIdentifire:nil];
    StartNavigationCoordinator* nav = [[StartNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createPinFlowController{
    return nil;
}

-(UIViewController*)createWalletFlowController{
    return nil;
}

-(UIViewController*)changePinFlowController{
    return nil;
}





@end
