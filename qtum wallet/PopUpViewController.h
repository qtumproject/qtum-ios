//
//  PopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpContent.h"

@interface PopUpViewController : UIViewController

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hide:(BOOL)animated completion:(void (^)(void))completion;
- (void)showFromView:(UIView *)view animated:(BOOL)animated completion:(void (^)(void))completion;

@property (strong, nonatomic) PopUpContent *content;

@end

@protocol PopUpViewControllerDelegate <NSObject>

- (void)okButtonPressed:(PopUpViewController *)sender;

@end

@protocol PopUpWithTwoButtonsViewControllerDelegate <PopUpViewControllerDelegate>

- (void)cancelButtonPressed:(PopUpViewController *)sender;

@end

@protocol SecurityPopupViewControllerDelegate <NSObject>

- (void)cancelButtonPressed:(PopUpViewController *)sender;
- (void)confirmButtonPressed:(PopUpViewController *)sender withPin:(NSString*) pin;

@end

@protocol ShareTokenPopupViewControllerDelegate <NSObject>

- (void)okButtonPressed:(PopUpViewController *)sender;
- (void)copyAddressButtonPressed:(PopUpViewController *)sender;
- (void)copyAbiButtonPressed:(PopUpViewController *)sender;

@end
