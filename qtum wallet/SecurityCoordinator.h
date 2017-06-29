//
//  SecurityCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 29.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SecurityCoordinator;

@protocol SecurityCoordinatorDelegate <NSObject>

- (void)coordinatorDidPassSecurity:(SecurityCoordinator*)coordinator;
- (void)coordinatorDidCancelePassSecurity:(SecurityCoordinator*)coordinator;

@end

@interface SecurityCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <SecurityCoordinatorDelegate> delegate;

- (instancetype)initWithParentViewContainer:(UIViewController*) containerViewController;
- (void)cancelPin;

@end
