//
//  TabBarCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TabBarCoordinator.h"

@interface TabBarCoordinator ()

@property (strong,nonatomic) UITabBarController* tabBarContoller;

@end

@implementation TabBarCoordinator

-(instancetype)initWithTabBarController:(UITabBarController*)tabBarController{
    self = [super init];
    if (self) {
        _tabBarContoller = tabBarController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    
}

@end
