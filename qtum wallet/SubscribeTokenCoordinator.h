//
//  SubscribeTokenCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"


@protocol SubscribeTokenCoordinatorDelegate <NSObject>

-(void)didBackButtonPressed;
-(void)didAddButtonPressed;
-(void)didBackButtonPressedFromAddNewToken;

@end

@interface SubscribeTokenCoordinator : BaseCoordinator <Coordinatorable,SubscribeTokenCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
