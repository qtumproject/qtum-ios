//
//  ControllersFactory.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WalletNameViewController;
@class LoginViewController;
@class FirstAuthViewController;
@class RestoreWalletViewController;
@class RepeateViewController;
@class CreatePinViewController;
@class AuthNavigationController;
@class ExportWalletBrandKeyViewController;
@class SubscribeTokenViewController;
@class RecieveViewController;
@class HistoryItemViewController;
@class CustomAbiInterphaseViewController;
@class CreateTokenFinishViewController;
@class TabBarCoordinator;
@class NoInternetConnectionPopUpViewController;
@class PhotoLibraryPopUpViewController;
@class TokenDetailsViewController;


@interface ControllersFactory : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

-(UIViewController*)profileFlowTab;
-(UIViewController*)newsFlowTab;
-(UIViewController*)sendFlowTab;
-(UINavigationController*)walletFlowTab;
-(UIViewController*)changePinFlowController;
-(UIViewController*)createPinFlowController;
-(UIViewController*)createWalletFlowController;
-(WalletNameViewController*)createWalletNameCreateController;
-(LoginViewController*)createLoginController;
-(FirstAuthViewController*)createFirstAuthController;
-(RestoreWalletViewController*)createRestoreWalletController;
-(CreatePinViewController*)createCreatePinController;
-(RepeateViewController*)createRepeatePinController;
-(AuthNavigationController*)createAuthNavigationController;
-(ExportWalletBrandKeyViewController*)createExportWalletBrandKeyViewController;
-(SubscribeTokenViewController*)createSubscribeTokenViewController;
-(RecieveViewController*)createRecieveViewController;
-(HistoryItemViewController*)createHistoryItem;
-(CustomAbiInterphaseViewController*)createCustomAbiInterphaseViewController;
-(CreateTokenFinishViewController*)createCreateTokenFinishViewController;
-(TokenDetailsViewController*)createTokenDetailsViewController;

// Pop ups
-(NoInternetConnectionPopUpViewController*)createNoInternetConnectionController;
-(PhotoLibraryPopUpViewController*)createPhotoLibraryController;

-(UIViewController*)createFlowNavigationCoordinator;
-(UIViewController*)createTabFlow;

@end
