//
//  CreateTokenCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"

@protocol CreateTokenCoordinatorDelegate <NSObject>

@required
-(void)createStepOneCancelDidPressed;
-(void)createStepOneNextDidPressedWithName:(NSString*) name andSymbol:(NSString*)symbol;
-(void)createStepTwoBackDidPressed;
-(void)createStepTwoNextDidPressedWithParam:(NSDictionary*)param;
-(void)createStepThreeBackDidPressed;
-(void)createStepThreeNextDidPressedWithSupply:(NSString*) supply andUnits:(NSString*)units;
-(void)createStepFourBackDidPressed;
-(void)createStepFourFinishDidPressed;

@end

@interface CreateTokenCoordinator : BaseCoordinator <Coordinatorable,CreateTokenCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
