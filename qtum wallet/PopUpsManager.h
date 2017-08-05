//
//  PopUpsManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopUpViewController.h"
#import "PopUpContentGenerator.h"

@class ConfirmPurchasePopUpViewController;
@class SecurityPopupViewController;
@class RestoreContractsPopUpViewController;
@class ShareTokenPopUpViewController;
@class ErrorPopUpViewController;
@class AddressTransferPopupViewController;

@interface PopUpsManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

// show methods
- (void)showNoIntenterConnetionsPopUp:(id<PopUpViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion;
- (void)showPhotoLibraryPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion;
- (ErrorPopUpViewController *)showErrorPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (void)showInformationPopUp:(id<PopUpViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (void)showConfirmPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (void)showLoaderPopUp;
- (RestoreContractsPopUpViewController *)showRestoreContractsPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (SecurityPopupViewController *)showSecurityPopup:(id<SecurityPopupViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (void)showSourceCodePopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (ConfirmPurchasePopUpViewController *)showConfirmPurchasePopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (ShareTokenPopUpViewController *)showShareTokenPopUp:(id<ShareTokenPopupViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion;
- (AddressTransferPopupViewController*)showAddressTransferPopupViewController:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter toAddress:(NSString*) address withFromAddressVariants:(NSDictionary<NSString*, NSNumber*>*) variants completion:(void (^)(void))completion;

// dismiss methods
- (void)dismissLoader;

// hide methods
- (void)hideCurrentPopUp:(BOOL)animated completion:(void (^)(void))completion;

@end
