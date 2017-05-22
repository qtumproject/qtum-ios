//
//  SubscribeTokenCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"


@protocol SubscribeTokenCoordinatorDelegate <NSObject>

-(void)didBackButtonPressed;
-(void)didAddButtonPressed;
-(void)didBackButtonPressedFromAddNewToken;
-(void)didScanButtonPressed;

@end

@interface SubscribeTokenCoordinator : BaseCoordinator <Coordinatorable,SubscribeTokenCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
