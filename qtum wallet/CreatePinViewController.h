//
//  CreatePinViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinCoordinator;

@interface CreatePinViewController : UIViewController

@property (weak,nonatomic) id <PinCoordinator> delegate;
@property (assign,nonatomic) PinType type;

@end
