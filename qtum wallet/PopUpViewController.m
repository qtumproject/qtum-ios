//
//  PopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpViewController.h"

BOOL ShowInUIWindow = YES;
CGFloat AnimationDuration = 0.3f;

@interface PopUpViewController ()

@property (nonatomic) PopUpContent *content;

@end

@implementation PopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)showFromViewController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (controller == nil) return;
    
    if (ShowInUIWindow) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if (animated) {
            self.view.alpha = 0.0f;
            [window addSubview:self.view];
            [UIView animateWithDuration:AnimationDuration animations:^{
                self.view.alpha = 1.0f;
            }];
        }else{
            [window addSubview:self.view];
        }
    }else{
        [controller presentViewController:self animated:animated completion:completion];
    }
}

- (void)hide:(BOOL)animated completion:(void (^)(void))completion
{
    if (ShowInUIWindow) {
        if (animated) {
            [UIView animateWithDuration:AnimationDuration animations:^{
                self.view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [self.view removeFromSuperview];
            }];
        }else{
            [self.view removeFromSuperview];
        }
    }else{
        [self dismissViewControllerAnimated:animated completion:completion];
    }
}

- (void)setContent:(PopUpContent *)content{
    _content = content;
}

- (PopUpContent *)getContent{
    return self.content;
}

@end
