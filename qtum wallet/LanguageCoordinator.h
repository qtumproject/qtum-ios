//
//  LanguageCoordinator.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"

@protocol LanguageCoordinatorDelegate <NSObject>

-(void)didBackButtonPressed;

@end

@interface LanguageCoordinator : BaseCoordinator <Coordinatorable,LanguageCoordinatorDelegate>

-(void)startWithoutAnimation;
-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
