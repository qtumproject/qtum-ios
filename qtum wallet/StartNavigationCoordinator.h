//
//  StartNavigationCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinViewController.h"


@interface StartNavigationCoordinator : UINavigationController <PinCoordinator>

@property (nonatomic, copy) void(^createPinCompletesion)();

@end
