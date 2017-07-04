//
//  ApplicationCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AuthCoordinator.h"
#import "LoginCoordinator.h"
#import "SecurityCoordinator.h"
#import "ConfirmPinCoordinator.h"
#import "NotificationManager.h"

@protocol ApplicationCoordinatorDelegate <NSObject>

@end

@interface ApplicationCoordinator : BaseCoordinator <Coordinatorable, ApplicationCoordinatorDelegate, SecurityCoordinatorDelegate, LoginCoordinatorDelegate, ConfirmPinCoordinatorDelegate, AuthCoordinatorDelegate>

@property (strong,nonatomic,readonly) NotificationManager* notificationManager;
@property (strong,nonatomic) id <Requestable> requestManager;

-(void)start;
//flows

- (void)startMainFlow;
- (void)startConfirmPinFlowWithHandler:(void(^)(BOOL)) handler;
- (void)startSecurityFlowWithHandler:(void(^)(BOOL)) handler;
- (void)startWalletFlow;
- (void)startCreatePinFlowWithCompletesion:(void(^)()) completesion;
- (void)startChangePinFlow;
- (void)startChangedLanguageFlow;

- (void)showWallet;
- (void)showExportBrainKeyAnimated:(BOOL)animated;
- (void)logout;
- (void)pushViewController:(UIViewController*) controller animated:(BOOL)animated;
- (void)setViewController:(UIViewController*) controller animated:(BOOL)animated;

//imessage
- (void)launchFromUrl:(NSURL*)url;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
