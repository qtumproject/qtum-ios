//
//  LoginViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinController.h"
#import "LoginViewOutput.h"
#import "LoginViewOutputDelegate.h"

@interface LoginViewController : PinController <LoginViewOutput>

@property (weak,nonatomic) id <LoginViewOutputDelegate> delegate;

@end
