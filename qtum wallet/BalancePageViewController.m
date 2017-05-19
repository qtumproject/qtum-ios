//
//  BalancePageViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "BalancePageViewController.h"
#import "CustomPageControl.h"

@interface BalancePageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation BalancePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
}

#pragma mark - Getters

-(void)setControllers:(NSArray <UIViewController <Paginationable>*>*)controllers {
    
    [self setViewControllers:@[controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _controllers = controllers;
}

#pragma mark - UIPageViewControllerDelegate

#pragma mark - UIPageViewControllerDataSource

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger viewControllerIndex = [self.controllers indexOfObject:(UIViewController <Paginationable>*)viewController];
    NSInteger prevIndex = viewControllerIndex - 1;
    
    if (prevIndex < 0) {
        return nil;
    }
    
    if (self.controllers.count < prevIndex) {
        return nil;
    }
    
    
    return self.controllers[prevIndex];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
 
    
    NSInteger viewControllerIndex = [self.controllers indexOfObject:(UIViewController <Paginationable>*)viewController];
    NSInteger nextIndex = viewControllerIndex + 1;
    
    NSInteger orderedViewControllersCount =  self.controllers.count;

    if (orderedViewControllersCount == nextIndex) {
        return nil;
    }
    
    if (orderedViewControllersCount < nextIndex) {
        return nil;
    }
    
    
    return self.controllers[nextIndex];
}


@end
