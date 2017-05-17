//
//  CreateTokenCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"
#import "ResultTokenCreateInputModel.h"

@protocol CreateTokenCoordinatorDelegate <NSObject>

@required
-(void)createStepOneCancelDidPressed;
-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenCreateInputModel*>*) inputs;
-(void)finishStepFinishDidPressed;
-(void)finishStepBackDidPressed;

@end

@interface CreateTokenCoordinator : BaseCoordinator <Coordinatorable,CreateTokenCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
