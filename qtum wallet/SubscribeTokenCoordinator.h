//
//  SubscribeTokenCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"


@protocol SubscribeTokenCoordinatorDelegate <NSObject>

-(void)didBackButtonPressed;
-(void)didAddNewPressed;
-(void)didBackButtonPressedFromAddNewToken;
-(void)didScanButtonPressed;
-(void)didAddNewTokenWithAddress:(NSString*) address;
-(void)didSelectContract:(Contract*) contract;

@end

@interface SubscribeTokenCoordinator : BaseCoordinator <Coordinatorable,SubscribeTokenCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
