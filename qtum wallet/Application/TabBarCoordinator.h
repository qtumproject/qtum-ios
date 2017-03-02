//
//  TabBarCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"

@protocol ApplicationCoordinatorDelegate;

@interface TabBarCoordinator : BaseCoordinator <Coordinatorable>

@property (weak,nonatomic) id <ApplicationCoordinatorDelegate> delegate;

-(instancetype)initWithTabBarController:(UITabBarController*)tabBarController;

@end
