//
//  PinViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePinRootController.h"


@protocol PinCoordinator;

@interface PinViewController : BaseViewController

@property (weak,nonatomic) id <PinCoordinator> delegate;
@property (assign,nonatomic) PinType type;

-(void)setCustomTitle:(NSString*) title;
-(void)actionIncorrectPin;


@end


