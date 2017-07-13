//
//  ConfirmPinForExportViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 12.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinController.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"

@interface ConfirmPinForExportViewController : PinController <LoginViewOutput>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForCancelButton;

@end
