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
#import "HistoryNavigationCoordinator.h"
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

-(UIViewController*)profileFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Profile" withIdentifire:@""];
    ProfileNavigationCoordinator* nav = [[ProfileNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)newsFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"News" withIdentifire:@""];
    NewsNavigationCoordinator* nav = [[NewsNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)sendFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Send" withIdentifire:@""];
    SendNavigationCoordinator* nav = [[SendNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)historyFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"History" withIdentifire:@""];
    HistoryNavigationCoordinator* nav = [[HistoryNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createFlowNavigationCoordinator{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Start" withIdentifire:@""];
    StartNavigationCoordinator* nav = [[StartNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createTabFlow{
    TabBarController* tabBar = [TabBarController new];
    return tabBar;
}

@end
