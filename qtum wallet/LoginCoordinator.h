//
//  LoginCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginCoordinatorDelegate <NSObject>

-(void)passwordDidEntered:(NSString*)password;
-(void)confirmPasswordDidCanceled;


@end

@interface LoginCoordinator : NSObject <Coordinatorable>

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end
