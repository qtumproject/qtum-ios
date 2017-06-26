//
//  LoginViewOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginViewOutput <NSObject>

-(void)applyFailedPasswordAction;
-(void)showLoginFields;

@end
