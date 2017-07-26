//
//  SecurityCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SecurityCoordinator;

@protocol SecurityCoordinatorDelegate <NSObject>

- (void)coordinatorDidPassSecurity:(SecurityCoordinator*)coordinator;
- (void)coordinatorDidCancelePassSecurity:(SecurityCoordinator*)coordinator;

@end

typedef NS_ENUM(NSInteger, SecurityCheckingType) {
    
    SendVerification,
    EnableTouchIdVerification
};

@interface SecurityCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <SecurityCoordinatorDelegate> delegate;
@property (assign, nonatomic) SecurityCheckingType type;

- (instancetype)initWithParentViewContainer:(UIViewController*) containerViewController;
- (void)cancelPin;

@end
