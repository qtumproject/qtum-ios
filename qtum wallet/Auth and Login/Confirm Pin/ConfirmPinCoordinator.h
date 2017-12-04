//
//  ConfirmPinCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ConfirmPinCoordinator;

@protocol ConfirmPinCoordinatorDelegate <NSObject>

- (void)coordinatorDidConfirm:(ConfirmPinCoordinator *) coordinator;

- (void)coordinatorDidCanceledConfirm:(ConfirmPinCoordinator *) coordinator;

@end

@interface ConfirmPinCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <ConfirmPinCoordinatorDelegate> delegate;

- (instancetype)initWithParentViewContainer:(UIViewController *) containerViewController;

@end
