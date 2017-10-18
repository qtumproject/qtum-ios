//
//  CreatePinViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "AuthCoordinator.h"
#import "PinController.h"
#import "CreatePinOutput.h"
#import "CreatePinOutputDelegate.h"
#import "PasswordView.h"

@interface CreatePinViewController : PinController <CreatePinOutput, PasswordViewDelegate>

@property (weak, nonatomic) IBOutlet PasswordView *passwordView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gradientViewBottomOffset;

@end
