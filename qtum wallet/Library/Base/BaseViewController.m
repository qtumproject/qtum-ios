//
//  BaseViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 22.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BaseViewController.h"
#import "UIAlertController+Extensions.h"

@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self conformsToProtocol:@protocol(ScrollableContentViewController)]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardFrameWillChange:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardFrameWillChange:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Alerts

- (void)showAlertWithTitle:(NSString *)title mesage:(NSString *)message andActions:(NSArray *)actions{
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

- (void)showCameraPermissionAlertWithTitle:(NSString *)title mesage:(NSString *)message andActions:(NSArray *)actions{
    UIAlertController* alert = [UIAlertController warningMessageWithSettingsButtonAndTitle:title
                                                                                   message:message
                                                                         withActionHandler:nil];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)keyboardFrameWillChange:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIViewAnimationCurve curve = [[sender userInfo][UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    UIViewAnimationOptions optionCurve = curve << 16;
    
    id <ScrollableContentViewController> scrollbaleSelf = (id<ScrollableContentViewController>)self;
    UIScrollView *scrollView =  scrollbaleSelf.scrollView;
    
    CGRect keyboardRect = [self.view convertRect:end fromView:nil];
    CGRect scrollViewRect = [self.view convertRect:scrollView.frame fromView:scrollView.superview];
    
    CGFloat scrollViewInsetDelta;
    if (CGRectIntersectsRect(keyboardRect, self.view.frame) == YES)
    scrollViewInsetDelta = CGRectIntersection(keyboardRect, scrollViewRect).size.height;
    else
    scrollViewInsetDelta = 0;
    
    void(^animations)() = ^{
        
        scrollView.contentInset = UIEdgeInsetsMake(scrollView.contentInset.top,
                                                   scrollView.contentInset.left,
                                                   scrollViewInsetDelta,
                                                   scrollView.contentInset.right);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(scrollView.scrollIndicatorInsets.top,
                                                            scrollView.scrollIndicatorInsets.left,
                                                            scrollViewInsetDelta,
                                                            scrollView.scrollIndicatorInsets.right);
    };
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState|optionCurve
                     animations:animations
                     completion:NULL];
}



@end
