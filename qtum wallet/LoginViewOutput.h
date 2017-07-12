//
//  LoginViewOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewOutputDelegate.h"

@protocol LoginViewOutput <NSObject>

@property (weak, nonatomic) id <LoginViewOutputDelegate> delegate;

-(void)applyFailedPasswordAction;
-(void)startEditing;
-(void)stopEditing;

@end
