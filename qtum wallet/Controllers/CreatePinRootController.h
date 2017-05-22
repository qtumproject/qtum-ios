//
//  CreatePinRootController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 14.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinViewController.h"
@protocol PinCoordinator;

@interface CreatePinRootController : UINavigationController <PinCoordinator>

@property (nonatomic, copy) void(^createPinCompletesion)();
@property (assign,nonatomic) BOOL animating;


@end
