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
@class ConstructorFromAbiViewController;
@class CreateTokenFinishViewController;
@class TokenFunctionViewController;
@class TokenFunctionDetailViewController;
@class TemplateTokenViewController;
@class TabBarCoordinator;
@class NoInternetConnectionPopUpViewController;
@class PhotoLibraryPopUpViewController;
@class TokenDetailsViewController;
@class AddNewTokensViewController;
@class QRCodeViewController;
@class SmartContractMenuViewController;
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
@class AddressTransferPopupViewController;

@protocol NewPaymentOutput;
@protocol WalletOutput;
@protocol TokenListOutput;
@protocol TabbarOutput;
@protocol FirstAuthOutput;
@protocol LanguageOutput;
@protocol ExportBrainKeyOutput;
@protocol HistoryItemOutput;
@protocol RecieveOutput;
@protocol LoginViewOutput;
@protocol LibraryOutput;
@protocol RestoreWalletOutput;
@protocol TokenDetailOutput;
@protocol ChangePinOutput;
@protocol WatchContractOutput;
@protocol SmartContractMenuOutput;
@protocol PublishedContractListOutput;
@protocol TemplatesListOutput;
@protocol RestoreContractsOutput;
@protocol BackupContractOutput;
@protocol ConstructorAbiOutput;
@protocol ContractCreationEndOutput;
@protocol ContractFunctionDetailOutput;
@protocol ContractFunctionsOutput;
@protocol AddressControlOutput;
@protocol TokenAddressLibraryOutput;
@protocol SplashScreenOutput;

@protocol QStoreMainOutput;
@protocol QStoreContractOutput;

@interface ControllersFactory : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

//Controllers
- (UIViewController*)profileFlowTab;
- (UIViewController*)newsFlowTab;
- (UIViewController*)sendFlowTab;
- (UINavigationController*)walletFlowTab;
- (UIViewController*)changePinFlowController;
- (UIViewController*)createPinFlowController;
- (UIViewController*)createWalletFlowController;
- (WalletNameViewController*)createWalletNameCreateController;
- (NSObject<LoginViewOutput>*)createLoginController;
- (NSObject<LoginViewOutput>*)createConfirmPinForExportViewController;
- (NSObject<FirstAuthOutput>*)createFirstAuthController;
- (NSObject<RestoreWalletOutput>*)createRestoreWalletController;
- (NSObject <ChangePinOutput>*)createChangePinController;
- (CreatePinViewController*)createCreatePinController;
- (RepeateViewController*)createRepeatePinController;
- (AuthNavigationController*)createAuthNavigationController;
- (ExportWalletBrandKeyViewController*)createExportWalletBrandKeyViewController;
- (SubscribeTokenViewController*)createSubscribeTokenViewController;
- (CreateTokenFinishViewController*)createCreateTokenFinishViewController;
- (AddNewTokensViewController*)createAddNewTokensViewController;
- (ChoseTokenPaymentViewController*)createChoseTokenPaymentViewController;
- (NSObject <SmartContractMenuOutput>*)createSmartContractMenuViewController;
- (EnableFingerprintViewController*)createEnableFingerprintViewController;

- (NSObject <TokenDetailOutput> *)createTokenDetailsViewController;
- (NSObject <TemplatesListOutput> *)createTemplateTokenViewController;
- (NSObject <PublishedContractListOutput>*)createSmartContractsListViewController;
- (NSObject <WatchContractOutput>*)createWatchContractViewController;
- (NSObject <WatchContractOutput>*)createWatchTokensViewController;
- (NSObject <NewPaymentOutput>*)createNewPaymentDarkViewController;
- (NSObject <WalletOutput> *)createWalletViewController;
- (NSObject <TokenListOutput> *)createTokenListViewController;
- (NSObject <LanguageOutput> *)createLanguageViewController;
- (NSObject <ExportBrainKeyOutput> *)createExportBrainKeyViewController;
- (NSObject <HistoryItemOutput> *)createHistoryItem;
- (NSObject <RecieveOutput> *)createRecieveViewController;
- (NSObject <LibraryOutput> *)createLibraryViewController;
- (NSObject <RestoreContractsOutput>*)createRestoreContractViewController;
- (NSObject <BackupContractOutput>*)createBackupContractViewController;
- (NSObject <ConstructorAbiOutput> *)createConstructorFromAbiViewController;
- (NSObject <ContractFunctionDetailOutput>*)createTokenFunctionDetailViewController;
- (NSObject <ContractFunctionsOutput> *)createTokenFunctionViewController;
- (NSObject <AddressControlOutput>*)createAddressControllOutput;
- (NSObject <TokenAddressLibraryOutput>*)createTokenAddressControllOutput;
- (NSObject <SplashScreenOutput> *)createSplashScreenOutput;

// QStore
- (NSObject <QStoreMainOutput> *)createQStoreMainViewController;
- (NSObject <QStoreContractOutput> *)createQStoreContractViewController;

- (QRCodeViewController*)createQRCodeViewControllerForWallet;
- (QRCodeViewController*)createQRCodeViewControllerForSend;
- (QRCodeViewController*)createQRCodeViewControllerForSubscribe;

// Pop ups
- (NoInternetConnectionPopUpViewController*)createNoInternetConnectionPopUpViewController;
- (PhotoLibraryPopUpViewController*)createPhotoLibraryPopUpViewController;
- (ErrorPopUpViewController*)createErrorPopUpViewController;
- (InformationPopUpViewController*)createInformationPopUpViewController;
- (ConfirmPopUpViewController*)createConfirmPopUpViewController;
- (LoaderPopUpViewController *)createLoaderViewController;
- (RestoreContractsPopUpViewController *)createRestoreContractsPopUpViewController;
- (SecurityPopupViewController *)createSecurityPopupViewController;

- (QStoreListViewController*)createQStoreListViewController;
- (SourceCodePopUpViewController *)createSourceCodePopUpViewController;
- (ConfirmPurchasePopUpViewController *)createConfirmPurchasePopUpViewController;
- (ShareTokenPopUpViewController *)createShareTokenPopUpViewController;
- (AddressTransferPopupViewController *)createAddressTransferPopupViewController;

- (UIViewController*)createFlowNavigationCoordinator;
- (UITabBarController <TabbarOutput>*)createTabFlow;


@end
