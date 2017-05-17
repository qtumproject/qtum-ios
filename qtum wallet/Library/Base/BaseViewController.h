//
//  BaseViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollableContentViewController <NSObject>

@required
@property (strong,nonatomic) UIScrollView* scrollView;

@end

@interface BaseViewController : UIViewController

// !actions || actions.count == 0 - "ok" as standart
- (void)showAlertWithTitle:(NSString *)title mesage:(NSString *)message andActions:(NSArray *)actions;
- (void)showCameraPermissionAlertWithTitle:(NSString *)title mesage:(NSString *)message andActions:(NSArray *)actions;

@end
