//
//  AuthCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"

@class AuthCoordinator;

@protocol AuthCoordinatorDelegate <NSObject>

- (void)coordinatorDidAuth:(AuthCoordinator*)coordinator;
- (void)coordinatorRequestForLogin;

@end

@protocol ApplicationCoordinatorDelegate;

@interface AuthCoordinator : BaseCoordinator <Coordinatorable>

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end
