//
//  LoginCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LoginMode){
    StartFirstSession,
    StartNewSession
};

@protocol ApplicationCoordinatorDelegate;

@interface LoginCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <ApplicationCoordinatorDelegate> delegate;
@property (assign, nonatomic) LoginMode mode;

- (instancetype)initWithParentViewContainer:(UIViewController*) containerViewController;

@end
