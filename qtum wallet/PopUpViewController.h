//
//  PopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpContent.h"

@interface PopUpViewController : UIViewController

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hide:(BOOL)animated completion:(void (^)(void))completion;

- (void)setContent:(PopUpContent *)content;
- (PopUpContent *)getContent;

@end

@protocol PopUpViewControllerDelegate <NSObject>

- (void)okButtonPressed:(PopUpViewController *)sender;

@end

@protocol PopUpWithTwoButtonsViewControllerDelegate <PopUpViewControllerDelegate>

- (void)cancelButtonPressed:(PopUpViewController *)sender;

@end
