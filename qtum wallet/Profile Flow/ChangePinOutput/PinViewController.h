//
//  PinViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "PinController.h"
#import "CreatePinRootController.h"
#import "ChangePinOutput.h"
#import "PasswordView.h"

@interface PinViewController : PinController <ChangePinOutput, PasswordViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomForButtonsConstraint;
@property (weak, nonatomic) IBOutlet PasswordView *passwordView;

@end


