//
//  ApplicationCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"
#import "SecurityCoordinator.h"
#import "Clearable.h"

@protocol ApplicationCoordinatorDelegate <NSObject>

@end

@interface ApplicationCoordinator : BaseCoordinator <Clearable>

- (void)start;
//flows

- (void)startConfirmPinFlowWithHandler:(void (^)(BOOL)) handler;

- (void)startSecurityFlowWithType:(SecurityCheckingType) type WithHandler:(void (^)(BOOL)) handler;

- (void)startChangedLanguageFlow;

- (void)startFromOpenURLWithAddress:(NSString *) address andAmount:(NSString *) amount;

- (void)startChanginTheme;

- (void)startSplashScreen;

- (void)logout;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
