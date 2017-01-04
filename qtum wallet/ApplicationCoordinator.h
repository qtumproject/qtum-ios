//
//  ApplicationCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ApplicationCoordinator : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

-(void)start;
//flows
-(void)startMainFlow;
-(void)startStartFlowWithAutorization:(BOOL) flag;
-(void)startWalletFlow;
-(void)startCreatePinFlowWithCompletesion:(void(^)()) completesion;
-(void)startChangePinFlow;

-(void)showWallet;
-(void)showExportBrainKeyAnimated:(BOOL)animated;

-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated;
-(void)setViewController:(UIViewController*) controller animated:(BOOL)animated;

@end
