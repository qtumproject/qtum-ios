//
//  LoginCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LoginCoordinatorDelegate <NSObject>

-(void)passwordDidEntered:(NSString*)password;
-(void)confirmPasswordDidCanceled;

@end

@protocol ApplicationCoordinatorDelegate;

@interface LoginCoordinator : BaseCoordinator <Coordinatorable>

@property (weak,nonatomic) id <ApplicationCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end
