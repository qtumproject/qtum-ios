//
//  ControllersFactory.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ControllersFactory.h"
#import "SendNavigationCoordinator.h"
#import "NewsNavigationController.h"
#import "ProfileNavigationCoordinator.h"
#import "UIViewController+Extension.h"
#import "TabBarController.h"
#import "WalletNameViewController.h"
#import "LoginViewController.h"
#import "FirstAuthViewController.h"
#import "RestoreWalletViewController.h"
#import "CreatePinViewController.h"
#import "RepeateViewController.h"
#import "AuthNavigationController.h"
#import "ExportWalletBrandKeyViewController.h"
#import "SubscribeTokenViewController.h"
#import "HistoryViewController.h"
#import "WalletNavigationController.h"
#import "RecieveViewController.h"
#import "HistoryItemViewController.h"
#import "NoInternetConnectionPopUpViewController.h"
#import "PhotoLibraryPopUpViewController.h"
#import "CustomAbiInterphaseViewController.h"
#import "CreateTokenFinishViewController.h"
#import "TokenDetailsViewController.h"
#import "LanguageViewController.h"
#import "BalancePageViewController.h"
#import "MainViewController.h"
#import "TokenListViewController.h"
#import "TokenFunctionViewController.h"
#import "TokenFunctionDetailViewController.h"
#import "TemplateTokenViewController.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "ChooseSmartContractViewController.h"
#import "SmartContractsListViewController.h"
#import "InformationPopUpViewController.h"
#import "ConfirmPopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "LoaderPopUpViewController.h"
#import "WatchContractViewController.h"
#import "WatchTokensViewController.h"
#import "RestoreContractsViewController.h"
#import "RestoreContractsPopUpViewController.h"
#import "BackupContractsViewController.h"

@implementation ControllersFactory

+ (instancetype)sharedInstance
{
    static ControllersFactory *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) { }
    return self;
}

-(UIViewController*)sendFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Send" withIdentifire:nil];
    SendNavigationCoordinator* nav = [[SendNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)profileFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"Profile" withIdentifire:nil];
    ProfileNavigationCoordinator* nav = [[ProfileNavigationCoordinator alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)newsFlowTab{
    UIViewController* controller = [UIViewController controllerInStoryboard:@"News" withIdentifire:nil];
    NewsNavigationController* nav = [[NewsNavigationController alloc] initWithRootViewController:controller];
    return nav;
}

-(UIViewController*)createTabFlow{
    TabBarController* tabBar = [TabBarController new];
    return tabBar;
}


-(UINavigationController*)walletFlowTab{
    BalancePageViewController* controller = [[BalancePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    controller.view.backgroundColor = customBlackColor();
    WalletNavigationController* nav = [[WalletNavigationController alloc] initWithRootViewController:controller];
    return nav;
}

-(WalletNameViewController*)createWalletNameCreateController{
    WalletNameViewController* controller = (WalletNameViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"WalletNameViewController"];
    return controller;
}

-(LoginViewController*)createLoginController{
    LoginViewController* controller = (LoginViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"LoginViewController"];
    return controller;
}

-(FirstAuthViewController*)createFirstAuthController{
    FirstAuthViewController* controller = (FirstAuthViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"FirstAuthViewController"];
    return controller;
}

-(RestoreWalletViewController*)createRestoreWalletController{
    RestoreWalletViewController* controller = (RestoreWalletViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"RestoreWalletViewController"];
    return controller;
}

-(CreatePinViewController*)createCreatePinController{
    CreatePinViewController* controller = (CreatePinViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"CreatePinViewController"];
    return controller;
}

-(RepeateViewController*)createRepeatePinController{
    RepeateViewController* controller = (RepeateViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"RepeateViewController"];
    return controller;
}

-(AuthNavigationController*)createAuthNavigationController {
    AuthNavigationController* controller = [[AuthNavigationController alloc]init];
    return controller;
}

-(ExportWalletBrandKeyViewController*)createExportWalletBrandKeyViewController{
    ExportWalletBrandKeyViewController* controller = (ExportWalletBrandKeyViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"ExportWalletBrandKeyViewController"];
    return controller;
}

-(SubscribeTokenViewController*)createSubscribeTokenViewController{
    SubscribeTokenViewController* controller = (SubscribeTokenViewController*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"SubscribeTokenViewController"];
    return controller;
}

-(LanguageViewController*)createLanguageViewController{
    LanguageViewController* controller = (LanguageViewController*)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"LanguageViewController"];
    return controller;
}

-(RecieveViewController*)createRecieveViewController{
    RecieveViewController* controller = (RecieveViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"RecieveViewController"];
    return controller;
}

-(HistoryItemViewController*)createHistoryItem{
    HistoryItemViewController* controller = (HistoryItemViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"HistoryItemViewController"];
    return controller;
}

-(MainViewController*)createMainViewController{
    MainViewController* controller = (MainViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"MainViewController"];
    return controller;
}

-(CustomAbiInterphaseViewController*)createCustomAbiInterphaseViewController{
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"CustomAbiInterphaseViewController"];
    return controller;
}

-(CreateTokenFinishViewController*)createCreateTokenFinishViewController{
    CreateTokenFinishViewController* controller = (CreateTokenFinishViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"CreateTokenFinishViewController"];
    return controller;
}

-(TokenDetailsViewController *)createTokenDetailsViewController{
    TokenDetailsViewController* controller = (TokenDetailsViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"TokenDetailsViewController"];
    return controller;
}

-(TokenListViewController*)createTokenListViewController{
    TokenListViewController* controller = (TokenListViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"TokenListViewController"];
    return controller;
}

-(TokenFunctionViewController*)createTokenFunctionViewController{
    TokenFunctionViewController* controller = (TokenFunctionViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"TokenFunctionViewController"];
    return controller;
}

-(TokenFunctionDetailViewController*)createTokenFunctionDetailViewController{
    TokenFunctionDetailViewController* controller = (TokenFunctionDetailViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"TokenFunctionDetailViewController"];
    return controller;
}

-(TemplateTokenViewController*)createTemplateTokenViewController{
    TemplateTokenViewController* controller = (TemplateTokenViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"TemplateTokenViewController"];
    return controller;
}

-(AddNewTokensViewController*)createAddNewTokensViewController{
    AddNewTokensViewController* controller = (AddNewTokensViewController*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"AddNewTokensViewController"];
    return controller;
}

-(QRCodeViewController*)createQRCodeViewControllerForSubscribe{
    QRCodeViewController* controller = (QRCodeViewController*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"QRCodeViewController"];
    return controller;
}

-(ChoseTokenPaymentViewController*)createChoseTokenPaymentViewController{
    ChoseTokenPaymentViewController* controller = (ChoseTokenPaymentViewController*)[UIViewController controllerInStoryboard:@"Send" withIdentifire:@"ChoseTokenPaymentViewController"];
    return controller;
}

-(ChooseSmartContractViewController*)createChooseSmartContractViewController{
    ChooseSmartContractViewController* controller = (ChooseSmartContractViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"ChooseSmartContractViewController"];
    return controller;
}

-(SmartContractsListViewController*)createSmartContractsListViewController{
    SmartContractsListViewController* controller = (SmartContractsListViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"SmartContractsListViewController"];
    return controller;
}


-(WatchContractViewController*)createWatchContractViewController{
    WatchContractViewController* controller = (WatchContractViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"WatchContractViewController"];
    return controller;
}


-(WatchTokensViewController*)createWatchTokensViewController{
    WatchTokensViewController* controller = (WatchTokensViewController*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"WatchTokensViewController"];
    return controller;
}

-(RestoreContractsViewController*)createRestoreContractViewController{
    RestoreContractsViewController* controller = (RestoreContractsViewController*)[UIViewController controllerInStoryboard:@"OnlyDesign" withIdentifire:@"RestoreContracts"];
    return controller;
}

-(BackupContractsViewController*)createBackupContractViewController{
    BackupContractsViewController* controller = (BackupContractsViewController*)[UIViewController controllerInStoryboard:@"OnlyDesign" withIdentifire:@"BackupContracts"];
    return controller;
}

-(UIViewController*)createFlowNavigationCoordinator{
    return nil;
}

-(UIViewController*)createPinFlowController{
    return nil;
}

-(UIViewController*)createWalletFlowController{
    return nil;
}

-(UIViewController*)changePinFlowController{
    return nil;
}

#pragma mark - Pop ups

-(NoInternetConnectionPopUpViewController*)createNoInternetConnectionPopUpViewController{
    NoInternetConnectionPopUpViewController* controller = (NoInternetConnectionPopUpViewController*)[UIViewController controllerInStoryboard:@"NoInternetConnectionPopUp" withIdentifire:@"NoInternetConnectionPopUp"];
    return controller;
}

-(PhotoLibraryPopUpViewController*)createPhotoLibraryPopUpViewController{
    PhotoLibraryPopUpViewController* controller = (PhotoLibraryPopUpViewController*)[UIViewController controllerInStoryboard:@"PhotoLibraryPopUp" withIdentifire:@"PhotoLibraryPopUp"];
    return controller;
}

- (ErrorPopUpViewController *)createErrorPopUpViewController{
    ErrorPopUpViewController* controller = (ErrorPopUpViewController*)[UIViewController controllerInStoryboard:@"ErrorPopUp" withIdentifire:@"ErrorPopUp"];
    return controller;
}

-(InformationPopUpViewController *)createInformationPopUpViewController{
    InformationPopUpViewController* controller = (InformationPopUpViewController*)[UIViewController controllerInStoryboard:@"InformationPopUp" withIdentifire:@"InformationPopUp"];
    return controller;
}

- (ConfirmPopUpViewController *)createConfirmPopUpViewController{
    ConfirmPopUpViewController* controller = (ConfirmPopUpViewController*)[UIViewController controllerInStoryboard:@"ConfirmPopUp" withIdentifire:@"ConfirmPopUp"];
    return controller;
}

- (LoaderPopUpViewController *)createLoaderViewController{
    LoaderPopUpViewController* controller = (LoaderPopUpViewController *)[UIViewController controllerInStoryboard:@"LoaderPopUp" withIdentifire:@"LoaderPopUp"];
    return controller;
}

- (RestoreContractsPopUpViewController *)createRestoreContractsPopUpViewController{
    RestoreContractsPopUpViewController* controller = (RestoreContractsPopUpViewController *)[UIViewController controllerInStoryboard:@"RestoreContractsPopUp" withIdentifire:@"RestoreContractsPopUp"];
    return controller;
}

@end
