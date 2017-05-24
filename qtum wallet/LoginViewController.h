//
//  LoginViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "PinController.h"

@interface LoginViewController : PinController

@property (weak,nonatomic) id <LoginCoordinatorDelegate> delegate;

-(void)applyFailedPasswordAction;

@end
