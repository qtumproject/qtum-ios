//
//  SendCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SendCoordinatorDelegate <NSObject>

@end

@interface SendCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <SendCoordinatorDelegate> delegate;

@end
