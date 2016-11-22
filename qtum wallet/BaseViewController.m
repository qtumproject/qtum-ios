//
//  BaseViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
//{
//    if (flag) {
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//    }else{
//        [super presentViewController:viewControllerToPresent animated:NO completion:completion];
//    }
//}
//
//- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
//{
//    if (flag) {
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.3;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromLeft;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//    }
//    
//    [super dismissViewControllerAnimated:NO completion:nil];
//}

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *)title mesage:(NSString *)message andActions:(NSArray *)actions
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (!actions || actions.count == 0) {
        UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
    }else{
        for (UIAlertAction *action in actions) {
            [alert addAction:action];
        }
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
