//
//  PopUpsManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PopUpViewController.h"

@interface PopUpsManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

// show methods
- (void)showNoIntenterConnetionsPopUp:(id<PopUpViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion;
- (void)showPhotoLibraryPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion;

// hide methods
- (void)hideCurrentPopUp:(BOOL)animated completion:(void (^)(void))completion;

@end
