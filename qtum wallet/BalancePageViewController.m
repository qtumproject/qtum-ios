//
//  BalancePageViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BalancePageViewController.h"
#import "CustomPageControl.h"

@interface BalancePageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate>

@property (nonatomic) NSInteger currentIndex;
@property (assign,nonatomic) BOOL needSwipeBack;
@property (weak,nonatomic) UIScrollView* scrollView;


@end

@implementation BalancePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self setDelegateToScrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needSwipeBack) {
        [self scrollToRootIfNeededAnimated:NO];
    }
}

- (void)setDelegateToScrollView{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delegate = self;
            self.scrollView = (UIScrollView *)view;
            break;
        }
    }
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

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    NSUInteger index = [self.controllers indexOfObject: [pageViewController.viewControllers firstObject]];
    self.currentIndex = index;
}

#pragma makr - Public Methods

-(void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index < 0 || index >= self.controllers.count) {
        return;
    }

    [self setViewControllers:@[self.controllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:animated completion:nil];
    self.currentIndex = index;
}

-(void)scrollToRootIfNeededAnimated:(BOOL)animated{
    
    if (self.isViewLoaded && self.view.window && self.currentIndex) {
        [self scrollToIndex:0 animated:animated];
        self.needSwipeBack = NO;
        [self setScrollEnable:NO];
    } else if (self.currentIndex){
        self.needSwipeBack = true;
    }else {
        [self setScrollEnable:NO];
    }
}

-(void)setScrollingToTokensAvailableIfNeeded {
    [self setScrollEnable:YES];
}

- (void)setScrollEnable:(BOOL)enable {
    self.scrollView.scrollEnabled = enable;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.currentIndex == 0 && scrollView.contentOffset.x < scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    } else if (self.currentIndex == self.controllers.count - 1 && scrollView.contentOffset.x > scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.currentIndex == 0 && scrollView.contentOffset.x <= scrollView.bounds.size.width) {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    } else if (self.currentIndex == self.controllers.count - 1 && scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        *targetContentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

@end
