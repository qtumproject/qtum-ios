//
//  CreatePinViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AuthCoordinator.h"
#import "PinController.h"

@interface CreatePinViewController : PinController

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

@end
