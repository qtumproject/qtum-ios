//
//  SlideNavigationContorllerAnimatorFade+FadeController.m
//  TCA2016
//
//  Created by Sharaev Vladimir on 09.08.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "SlideNavigationContorllerAnimatorFade+FadeController.h"
#import <objc/runtime.h>

@implementation SlideNavigationContorllerAnimatorFade (FadeController)
@dynamic fadeView;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelectorPrepare = @selector(prepareMenuForAnimation:);
        SEL swizzledSelectorPrepare = @selector(prepareControllerForAnimation:);
        
        Method originalMethodPrepare = class_getInstanceMethod(class, originalSelectorPrepare);
        Method swizzledMethodPrepare = class_getInstanceMethod(class, swizzledSelectorPrepare);
        
        SEL originalSelectorAnimate = @selector(animateMenu:withProgress:);
        SEL swizzledSelectorAnimate = @selector(animateController:withProgress:);
        
        Method originalMethodAnimate = class_getInstanceMethod(class, originalSelectorAnimate);
        Method swizzledMethodAnimate = class_getInstanceMethod(class, swizzledSelectorAnimate);
        
        SEL originalSelectorClear = @selector(clear);
        SEL swizzledSelectorClear = @selector(clearController);
        
        Method originalMethodClear = class_getInstanceMethod(class, originalSelectorClear);
        Method swizzledMethodClear = class_getInstanceMethod(class, swizzledSelectorClear);
        
        BOOL didAddMethodPrepare = class_addMethod(class, originalSelectorPrepare,
                                                   method_getImplementation(swizzledMethodPrepare),
                                                   method_getTypeEncoding(swizzledMethodPrepare));
        
        BOOL didAddMethodAnimate = class_addMethod(class, originalSelectorAnimate,
                                                   method_getImplementation(swizzledMethodAnimate),
                                                   method_getTypeEncoding(swizzledMethodAnimate));
        
        BOOL didAddMethodClear = class_addMethod(class, originalSelectorClear,
                                                   method_getImplementation(swizzledMethodClear),
                                                   method_getTypeEncoding(swizzledMethodClear));
        
        if (didAddMethodPrepare) {
            class_replaceMethod(class,
                                swizzledSelectorPrepare,
                                method_getImplementation(originalMethodPrepare),
                                method_getTypeEncoding(originalMethodPrepare));
        } else {
            method_exchangeImplementations(originalMethodPrepare, swizzledMethodPrepare);
        }
        
        if (didAddMethodAnimate) {
            class_replaceMethod(class,
                                swizzledSelectorAnimate,
                                method_getImplementation(originalMethodAnimate),
                                method_getTypeEncoding(originalMethodAnimate));
        } else {
            method_exchangeImplementations(originalMethodAnimate, swizzledMethodAnimate);
        }
        
        if (didAddMethodClear) {
            class_replaceMethod(class,
                                swizzledSelectorClear,
                                method_getImplementation(originalMethodClear),
                                method_getTypeEncoding(originalMethodClear));
        } else {
            method_exchangeImplementations(originalMethodClear, swizzledMethodClear);
        }
    });
}

#pragma mark - SlideNavigationContorllerAnimation Methods

- (void)prepareControllerForAnimation:(Menu)menu
{
    UIViewController *vc = [SlideNavigationController sharedInstance].viewControllers.lastObject;
    
    if (!self.fadeView) {
        [self createFadeView:vc];
    }
    
//    self.fadeView.frame = vc.view.bounds;
    self.fadeView.frame = [[UIApplication sharedApplication].windows lastObject].bounds;
}

- (void)animateController:(Menu)menu withProgress:(CGFloat)progress
{
    UIViewController *vc = [SlideNavigationController sharedInstance].viewControllers.lastObject;
    
    if (!self.fadeView) {
        [self createFadeView:vc];
    }
    
//    self.fadeView.frame = vc.view.bounds;
    self.fadeView.frame = [[UIApplication sharedApplication].windows lastObject].bounds;
    [vc.view addSubview:self.fadeView];
    self.fadeView.alpha = self.maximumFadeAlpha * progress;
}

- (void)createFadeView:(UIViewController *)vc
{
    self.fadeView = [[UIView alloc] init];
    self.fadeView.backgroundColor = self.fadeColor;
}

- (void)clearController
{
    [self.fadeView removeFromSuperview];
}

#pragma mark - Property

- (UIView *)fadeView
{
    return objc_getAssociatedObject(self, @"fadeView");
}

- (void)setFadeView:(UIView *)fadeView
{
    objc_setAssociatedObject(self, @"fadeView", fadeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
