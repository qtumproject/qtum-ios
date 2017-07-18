//
//  ConfirmPinForExportViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinController.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"

@interface ConfirmPinForExportViewController : PinController <LoginViewOutput>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForCancelButton;

@end
