//
//  ControllersFactory.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
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
@class TokenFunctionViewController;
@class TokenFunctionDetailViewController;
@class TemplateTokenViewController;
@class TabBarCoordinator;
@class NoInternetConnectionPopUpViewController;
@class PhotoLibraryPopUpViewController;
@class TokenDetailsViewController;
@class LanguageViewController;
@class AddNewTokensViewController;
@class QRCodeViewController;
@class ChooseSmartContractViewController;
@class SmartContractsListViewController;
@class ChoseTokenPaymentViewController;
@class ErrorPopUpViewController;
@class InformationPopUpViewController;
@class ConfirmPopUpViewController;
@class WatchContractViewController;
@class WatchTokensViewController;
@class LoaderPopUpViewController;
@class RestoreContractsViewController;
@class RestoreContractsPopUpViewController;
@class BackupContractsViewController;
@class EnableFingerprintViewController;
@class SecurityPopupViewController;
@class QStoreViewController;
@class SourceCodePopUpViewController;
@class QStoreListViewController;
@class QStoreContractViewController;
@class ConfirmPurchasePopUpViewController;

@protocol NewPaymentOutput;
@protocol WalletOutput;
@protocol TokenListOutput;

@interface ControllersFactory : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

//Controllers
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
-(LanguageViewController*)createLanguageViewController;
-(AddNewTokensViewController*)createAddNewTokensViewController;
-(ChoseTokenPaymentViewController*)createChoseTokenPaymentViewController;
-(ChooseSmartContractViewController*)createChooseSmartContractViewController;
-(SmartContractsListViewController*)createSmartContractsListViewController;
-(TokenFunctionViewController*)createTokenFunctionViewController;
-(TokenFunctionDetailViewController*)createTokenFunctionDetailViewController;
-(TemplateTokenViewController*)createTemplateTokenViewController;
-(WatchContractViewController*)createWatchContractViewController;
-(WatchTokensViewController*)createWatchTokensViewController;
-(RestoreContractsViewController*)createRestoreContractViewController;
-(BackupContractsViewController*)createBackupContractViewController;
-(EnableFingerprintViewController*)createEnableFingerprintViewController;
-(NSObject <NewPaymentOutput>*)createNewPaymentDarkViewController;
-(NSObject<WalletOutput> *)createWalletViewController;
-(NSObject<TokenListOutput> *)createTokenListViewController;

-(QRCodeViewController*)createQRCodeViewControllerForWallet;
-(QRCodeViewController*)createQRCodeViewControllerForSend;
-(QRCodeViewController*)createQRCodeViewControllerForSubscribe;

// Pop ups
- (NoInternetConnectionPopUpViewController*)createNoInternetConnectionPopUpViewController;
- (PhotoLibraryPopUpViewController*)createPhotoLibraryPopUpViewController;
- (ErrorPopUpViewController*)createErrorPopUpViewController;
- (InformationPopUpViewController*)createInformationPopUpViewController;
- (ConfirmPopUpViewController*)createConfirmPopUpViewController;
- (LoaderPopUpViewController *)createLoaderViewController;
- (RestoreContractsPopUpViewController *)createRestoreContractsPopUpViewController;
- (SecurityPopupViewController *)createSecurityPopupViewController;
- (QStoreViewController*)createQStoreViewController;
- (QStoreListViewController*)createQStoreListViewController;
- (QStoreContractViewController*)createQStoreContractViewController;
- (SourceCodePopUpViewController *)createSourceCodePopUpViewController;
- (ConfirmPurchasePopUpViewController *)createConfirmPurchasePopUpViewController;

-(UIViewController*)createFlowNavigationCoordinator;
-(UIViewController*)createTabFlow;

@end
