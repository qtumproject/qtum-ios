//
//  CreatePinViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AuthCoordinator.h"
#import "PinController.h"
#import "CreatePinOutput.h"
#import "CreatePinOutputDelegate.h"

@interface CreatePinViewController : PinController <CreatePinOutput>

@end
