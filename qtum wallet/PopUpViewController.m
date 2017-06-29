//
//  PopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpViewController.h"

CGFloat AnimationDuration = 0.3f;

@interface PopUpViewController ()

@property (assign, nonatomic) BOOL showInUIWindow;

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.showInUIWindow = !controller;
    UIView* rootView;
    
    if (self.showInUIWindow) {
        rootView = [UIApplication sharedApplication].keyWindow;
    } else {
        rootView = controller.view;
    }
    
    if (animated) {
        self.view.alpha = 0.0f;
        [rootView addSubview:self.view];
        [UIView animateWithDuration:AnimationDuration animations:^{
            self.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            if (completion) completion();
        }];
    }else{
        [rootView addSubview:self.view];
        if (completion) completion();
    }
}

- (void)hide:(BOOL)animated completion:(void (^)(void))completion {
    
    if (animated) {
        [UIView animateWithDuration:AnimationDuration animations:^{
            self.view.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            if (completion) completion();
        }];
    }else{
        [self.view removeFromSuperview];
        if (completion) completion();
    }
}

@end
