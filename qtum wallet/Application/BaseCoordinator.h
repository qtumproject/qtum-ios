//
//  BaseCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coordinatorable.h"

@interface BaseCoordinator : NSObject <Coordinatorable>

-(void)addDependency:(id <Coordinatorable>) coordinator;
-(void)removeDependency:(id <Coordinatorable>) coordinator;

@end
