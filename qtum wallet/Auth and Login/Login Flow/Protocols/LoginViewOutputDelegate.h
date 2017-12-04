//
//  LoginViewOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginViewOutputDelegate <NSObject>

- (void)passwordDidEntered:(NSString *) password;

- (void)confirmPasswordDidCanceled;

@end
