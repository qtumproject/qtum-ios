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
#import "TabBarControllerDark.h"
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
#import "CustomAbiInterphaseViewController.h"
#import "CreateTokenFinishViewController.h"
#import "TokenDetailsViewController.h"
#import "TokenFunctionViewController.h"
#import "TokenFunctionDetailViewController.h"
#import "TemplateTokenViewController.h"
#import "AddNewTokensViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "SmartContractMenuViewController.h"
#import "SmartContractsListViewController.h"
#import "WatchContractViewController.h"
#import "WatchTokensViewController.h"
#import "RestoreContractsViewController.h"
#import "EnableFingerprintViewController.h"
#import "QStoreViewController.h"
#import "QStoreListViewController.h"
#import "QStoreContractViewController.h"
#import "TabBarControllerLight.h"
#import "NSUserDefaults+Settings.h"
#import "PinViewController.h"

#import "SecurityPopupViewController.h"
#import "RestoreContractsPopUpViewController.h"
#import "LoaderPopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "ConfirmPopUpViewController.h"
#import "NoInternetConnectionPopUpViewController.h"
#import "PhotoLibraryPopUpViewController.h"
#import "SourceCodePopUpViewController.h"
#import "ConfirmPurchasePopUpViewController.h"
#import "ShareTokenPopUpViewController.h"
#import "InformationPopUpViewController.h"

#import "NewPaymentOutput.h"
#import "WalletOutput.h"
#import "BalancePageOutput.h"
#import "TokenListOutput.h"
#import "ProfileOutput.h"
#import "FirstAuthOutput.h"
#import "LanguageOutput.h"
#import "ExportBrainKeyOutput.h"
#import "HistoryItemOutput.h"
#import "RecieveOutput.h"
#import "LoginViewOutput.h"
#import "LibraryOutput.h"
#import "NewsOutput.h"
#import "TokenDetailOutput.h"
#import "SmartContractMenuOutput.h"
#import "PublishedContractListOutput.h"
#import "TemplatesListOutput.h"
#import "RestoreContractsOutput.h"
#import "BackupContractOutput.h"

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
    SendNavigationCoordinator* nav = [[SendNavigationCoordinator alloc] init];
    return nav;
}

-(UIViewController*)profileFlowTab {
    NSObject<ProfileOutput> *controller = (NSObject<ProfileOutput>*)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"ProfileViewController"];
    ProfileNavigationCoordinator* nav = [[ProfileNavigationCoordinator alloc] initWithRootViewController:[controller toPresent]];
    return nav;
}

-(UIViewController*)newsFlowTab {
    
    NSObject<NewsOutput> *controller = (NSObject<NewsOutput>*)[UIViewController controllerInStoryboard:@"News" withIdentifire:@"NewsViewController"];
    NewsNavigationController* nav = [[NewsNavigationController alloc] initWithRootViewController:[controller toPresent]];
    return nav;
}

-(UITabBarController <TabbarOutput>*)createTabFlow {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [TabBarControllerDark new];
    } else {
        return [TabBarControllerLight new];
    }
}

-(UINavigationController*)walletFlowTab {
    
    NSObject<BalancePageOutput> *controller = (NSObject<BalancePageOutput>*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"BalancePageViewController"];
    WalletNavigationController* nav = [[WalletNavigationController alloc] initWithRootViewController:[controller toPresent]];
    return nav;
}

-(NSObject<NewPaymentOutput>*)createNewPaymentDarkViewController {
    
    NSObject<NewPaymentOutput>* controller = (NSObject<NewPaymentOutput>*)[UIViewController controllerInStoryboard:@"Send" withIdentifire:@"NewPayment"];
    return controller;
}

- (QRCodeViewController*)createQRCodeViewControllerForSend {
    
    QRCodeViewController* controller = (QRCodeViewController*)[UIViewController controllerInStoryboard:@"Send" withIdentifire:@"QRCodeViewController"];
    return controller;
}

-(WalletNameViewController*)createWalletNameCreateController{
    WalletNameViewController* controller = (WalletNameViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"WalletNameViewController"];
    return controller;
}

-(NSObject<LoginViewOutput>*)createLoginController{
    NSObject<LoginViewOutput>* controller = (NSObject<LoginViewOutput>*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"LoginViewController"];
    return controller;
}

-(NSObject<LoginViewOutput>*)createConfirmPinForExportViewController{
    NSObject<LoginViewOutput>* controller = (NSObject<LoginViewOutput>*)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"ConfirmPinForExportViewController"];
    return controller;
}

-(NSObject<FirstAuthOutput>*)createFirstAuthController{
    NSObject<FirstAuthOutput>* controller = (FirstAuthViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"FirstAuthViewController"];
    return controller;
}

-(NSObject<RestoreWalletOutput>*)createRestoreWalletController {
    
    NSObject<RestoreWalletOutput>* controller = (NSObject<RestoreWalletOutput>*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"RestoreWalletViewController"];
    return controller;
}

-(CreatePinViewController*)createCreatePinController{
    CreatePinViewController* controller = (CreatePinViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"CreatePinViewController"];
    return controller;
}

- (NSObject <ChangePinOutput>*)createChangePinController{
    NSObject <ChangePinOutput>* output = (NSObject <ChangePinOutput>*)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"PinViewController"];
    return output;
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

-(NSObject <SubscribeTokenOutput>*)createSubscribeTokenViewController {
    
    NSObject <SubscribeTokenOutput>* output = (NSObject <SubscribeTokenOutput>*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"SubscribeTokenViewController"];
    return output;
}

-(NSObject<LanguageOutput> *)createLanguageViewController{
    NSObject<LanguageOutput> *controller = (NSObject<LanguageOutput> *)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"LanguageViewController"];
    return controller;
}

-(NSObject<ExportBrainKeyOutput> *)createExportBrainKeyViewController{
    NSObject<ExportBrainKeyOutput> *controller = (NSObject<ExportBrainKeyOutput> *)[UIViewController controllerInStoryboard:@"Profile" withIdentifire:@"ExportBrainKeyViewController"];
    return controller;
}

-(NSObject<RecieveOutput> *)createRecieveViewController{
    NSObject<RecieveOutput> *controller = (NSObject<RecieveOutput> *)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"RecieveViewController"];
    return controller;
}

-(NSObject<HistoryItemOutput> *)createHistoryItem{
    NSObject<HistoryItemOutput> *controller = (NSObject<HistoryItemOutput> *)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"HistoryItemViewController"];
    return controller;
}

-(NSObject<WalletOutput> *)createWalletViewController{
    NSObject<WalletOutput> *controller = (NSObject<WalletOutput> *)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"WalletViewController"];
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

-(NSObject <TokenDetailOutput> *)createTokenDetailsViewController {
    NSObject <TokenDetailOutput> * controller = (NSObject <TokenDetailOutput> *)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"TokenDetailsViewController"];
    return controller;
}

-(NSObject<TokenListOutput> *)createTokenListViewController{
    NSObject<TokenListOutput> *controller = (NSObject<TokenListOutput> *)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"TokenListViewController"];
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

-(NSObject<TemplatesListOutput> *)createTemplateTokenViewController {
    
    NSObject<TemplatesListOutput> *output = (NSObject<TemplatesListOutput> *)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"TemplateTokenViewController"];
    return output;
}

-(AddNewTokensViewController*)createAddNewTokensViewController{
    AddNewTokensViewController* controller = (AddNewTokensViewController*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"AddNewTokensViewController"];
    return controller;
}

-(QRCodeViewController*)createQRCodeViewControllerForSubscribe{
    QRCodeViewController* controller = (QRCodeViewController*)[UIViewController controllerInStoryboard:@"SubscribeToken" withIdentifire:@"QRCodeViewController"];
    return controller;
}

-(QRCodeViewController*)createQRCodeViewControllerForWallet{
    QRCodeViewController* controller = (QRCodeViewController*)[UIViewController controllerInStoryboard:@"Wallet" withIdentifire:@"QRCodeViewController"];
    return controller;
}

-(ChoseTokenPaymentViewController*)createChoseTokenPaymentViewController {
    ChoseTokenPaymentViewController* controller = (ChoseTokenPaymentViewController*)[UIViewController controllerInStoryboard:@"Send" withIdentifire:@"ChoseTokenPaymentViewController"];
    return controller;
}

-(NSObject <SmartContractMenuOutput>*)createSmartContractMenuViewController {
    
    NSObject <SmartContractMenuOutput>* controller = (NSObject <SmartContractMenuOutput>*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"SmartContractMenuViewController"];
    return controller;
}

-(NSObject <PublishedContractListOutput>*)createSmartContractsListViewController {
    
    NSObject <PublishedContractListOutput>* controller = (NSObject <PublishedContractListOutput>*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"SmartContractsListViewController"];
    return controller;
}

-(QStoreViewController*)createQStoreViewController{
    QStoreViewController* controller = (QStoreViewController*)[UIViewController controllerInStoryboard:@"QStore" withIdentifire:@"QStoreViewController"];
    return controller;
}

-(QStoreListViewController*)createQStoreListViewController{
    QStoreListViewController* controller = (QStoreListViewController*)[UIViewController controllerInStoryboard:@"QStore" withIdentifire:@"QStoreListViewController"];
    return controller;
}

-(QStoreContractViewController*)createQStoreContractViewController{
    QStoreContractViewController* controller = (QStoreContractViewController*)[UIViewController controllerInStoryboard:@"QStore" withIdentifire:@"QStoreContractViewController"];
    return controller;
}

-(NSObject <WatchContractOutput>*)createWatchContractViewController {
    NSObject <WatchContractOutput>* controller = (NSObject <WatchContractOutput>*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"WatchContractViewController"];
    return controller;
}


-(NSObject <WatchContractOutput>*)createWatchTokensViewController {
    NSObject <WatchContractOutput>* controller = (NSObject <WatchContractOutput>*)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"WatchTokensViewController"];
    return controller;
}

-(NSObject <RestoreContractsOutput>*)createRestoreContractViewController{
    
    NSObject <RestoreContractsOutput>* controller = (NSObject <RestoreContractsOutput>*)[UIViewController controllerInStoryboard:@"OnlyDesign" withIdentifire:@"RestoreContractsViewController"];
    return controller;
}

-(NSObject <BackupContractOutput>*)createBackupContractViewController {
    
    NSObject <BackupContractOutput>* outbut = (NSObject <BackupContractOutput>*)[UIViewController controllerInStoryboard:@"OnlyDesign" withIdentifire:@"BackupContractsViewController"];
    return outbut;
}

-(EnableFingerprintViewController*)createEnableFingerprintViewController{
    EnableFingerprintViewController* controller = (EnableFingerprintViewController*)[UIViewController controllerInStoryboard:@"Start" withIdentifire:@"EnableFingerprintViewController"];
    return controller;
}

-(NSObject<LibraryOutput> *)createLibraryViewController{
    NSObject<LibraryOutput> *controller = (NSObject<LibraryOutput> *)[UIViewController controllerInStoryboard:@"CreateToken" withIdentifire:@"LibraryViewController"];
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
    NoInternetConnectionPopUpViewController* controller = (NoInternetConnectionPopUpViewController*)[UIViewController controllerInStoryboard:@"NoInternetConnectionPopUp" withIdentifire:@"NoInternetConnectionPopUpViewController"];
    return controller;
}

-(PhotoLibraryPopUpViewController*)createPhotoLibraryPopUpViewController{
    PhotoLibraryPopUpViewController* controller = (PhotoLibraryPopUpViewController*)[UIViewController controllerInStoryboard:@"PhotoLibraryPopUp" withIdentifire:@"PhotoLibraryPopUpViewController"];
    return controller;
}

- (ErrorPopUpViewController *)createErrorPopUpViewController{
    ErrorPopUpViewController* controller = (ErrorPopUpViewController*)[UIViewController controllerInStoryboard:@"ErrorPopUp" withIdentifire:@"ErrorPopUpViewController"];
    return controller;
}

-(InformationPopUpViewController *)createInformationPopUpViewController{
    InformationPopUpViewController* controller = (InformationPopUpViewController*)[UIViewController controllerInStoryboard:@"InformationPopUp" withIdentifire:@"InformationPopUpViewController"];
    return controller;
}

- (ConfirmPopUpViewController *)createConfirmPopUpViewController{
    ConfirmPopUpViewController* controller = (ConfirmPopUpViewController*)[UIViewController controllerInStoryboard:@"ConfirmPopUp" withIdentifire:@"ConfirmPopUp"];
    return controller;
}

- (LoaderPopUpViewController *)createLoaderViewController{
    LoaderPopUpViewController* controller = (LoaderPopUpViewController *)[UIViewController controllerInStoryboard:@"LoaderPopUp" withIdentifire:@"LoaderPopUpViewController"];
    return controller;
}

- (RestoreContractsPopUpViewController *)createRestoreContractsPopUpViewController {
    
    RestoreContractsPopUpViewController* controller = (RestoreContractsPopUpViewController *)[UIViewController controllerInStoryboard:@"RestoreContractsPopUp" withIdentifire:@"RestoreContractsPopUpViewController"];
    return controller;
}

- (SourceCodePopUpViewController *)createSourceCodePopUpViewController{
    SourceCodePopUpViewController* controller = (SourceCodePopUpViewController *)[UIViewController controllerInStoryboard:@"SourceCodePopUp" withIdentifire:@"SourceCodePop"];
    return controller;
}

- (SecurityPopupViewController *)createSecurityPopupViewController{
    SecurityPopupViewController* controller = (SecurityPopupViewController *)[UIViewController controllerInStoryboard:@"SecurityPopup" withIdentifire:@"SecurityPopupViewController"];
    return controller;
}


- (ConfirmPurchasePopUpViewController *)createConfirmPurchasePopUpViewController{
    ConfirmPurchasePopUpViewController* controller = (ConfirmPurchasePopUpViewController *)[UIViewController controllerInStoryboard:@"ConfirmPurchasePopUp" withIdentifire:@"ConfirmPurchasePopUp"];
    return controller;
}

- (ShareTokenPopUpViewController *)createShareTokenPopUpViewController{
    ShareTokenPopUpViewController* controller = (ShareTokenPopUpViewController *)[UIViewController controllerInStoryboard:@"ShareTokenPopUp" withIdentifire:@"ShareTokenPopUpViewController"];
    return controller;
}

@end
