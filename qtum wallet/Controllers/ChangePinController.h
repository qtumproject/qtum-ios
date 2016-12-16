//
//  ChangePinController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 16.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinViewController.h"
@protocol PinCoordinator;

@interface ChangePinController : UINavigationController <PinCoordinator>

@property (nonatomic, copy) void(^changePinCompletesion)();
@property (assign,nonatomic) BOOL animating;

@end
