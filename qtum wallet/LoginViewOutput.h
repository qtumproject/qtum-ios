//
//  LoginViewOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewOutputDelegate.h"
#import "PasswordView.h"

@protocol LoginViewOutput <NSObject>

@property (weak, nonatomic) id <LoginViewOutputDelegate> delegate;

- (void)applyFailedPasswordAction;

@optional
- (void)startEditing;

- (void)stopEditing;

- (void)clearTextFileds;

- (void)setInputsDisable:(BOOL) disable;

@end
