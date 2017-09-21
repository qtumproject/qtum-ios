//
//  BalancePageViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BalancePageViewController.h"
#import "CustomPageControl.h"

@interface BalancePageViewController () <UIScrollViewDelegate>


@property (nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL needSwipeBack;
@property (assign, nonatomic) BOOL viewWasShowed;
@property (assign, nonatomic) BOOL enabledScroll;

@property (nonatomic) UIView *container;
@property (nonatomic) UIScrollView *scrollView;

@end

@implementation BalancePageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _enabledScroll = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createScrollView];
    [self addControllersToScroll];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.needSwipeBack) {
        [self scrollToRootIfNeededAnimated:NO];
    }
    
    self.viewWasShowed = YES;
}

- (UIView *)container {
    if (!_container) {
        _container = [UIView new];
        _container.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:_container];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : _container}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[container]-0-|" options:0 metrics:nil views:@{@"container" : _container}]];
    }
    return _container;
}

- (void)createScrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = _enabledScroll;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.bounces = NO;
        
        [self.view addSubview:_scrollView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll" : _scrollView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[scroll]-0-|" options:0 metrics:nil views:@{@"scroll" : _scrollView}]];
        
    }
}

- (void)addControllersToScroll {
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (self.controllers.count == 0) {
        return;
    }
    
    NSMutableString *horisontalString = [NSMutableString new];
    NSMutableDictionary *views = [NSMutableDictionary new];
    NSMutableArray *centerY = [NSMutableArray new];
    NSMutableArray *vertical = [NSMutableArray new];
    NSMutableArray *equalWidths = [NSMutableArray new];
    
    for (NSInteger i = 0; i < self.controllers.count; i++) {
        UIViewController *vc = [self.controllers objectAtIndex:i];
        [self addChildViewController:vc];
        UIView *view = vc.view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.scrollView addSubview:view];
        
        NSString *string;
        NSString *current = [NSString stringWithFormat:@"view%ld", (long)i];
        if (self.controllers.count == 1) {
            [views setObject:view forKey:current];
            string = [NSString stringWithFormat:@"H:|-0-[%@]-0-|", current];
        } else {
            if (i == 0) {
                [views setObject:view forKey:current];
                NSString *next = [NSString stringWithFormat:@"view%ld", (long)i + 1];
                [views setObject:[self.controllers objectAtIndex:i + 1].view forKey:next];
                
                string = [NSString stringWithFormat:@"H:|-0-[%@]-0-[%@]", current, next];
            } else if (i == self.controllers.count - 1) {
                string = [NSString stringWithFormat:@"-0-|"];
            }else {
                NSString *next = [NSString stringWithFormat:@"view%ld", (long)i + 1];
                [views setObject:[self.controllers objectAtIndex:i + 1].view forKey:next];
                
                string = [NSString stringWithFormat:@"-0-[%@]", next];
            }
        }
        
        [horisontalString appendString:string];
        
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
        
        [centerY addObject:centerYConstraint];
        
        NSArray *array = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[%@]-0-|", current] options:0 metrics:nil views:@{current : view}];
        
        [vertical addObjectsFromArray:array];
        
        NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
        
        [equalWidths addObject:equalWidth];
    }
    
    NSArray *horisontal = [NSLayoutConstraint constraintsWithVisualFormat:horisontalString options:0 metrics:nil views:views];
    
    [self.scrollView addConstraints:horisontal];
    [self.scrollView addConstraints:centerY];
    [self.scrollView addConstraints:vertical];
    [self.scrollView addConstraints:equalWidths];
    
    for (UIViewController *vc in _controllers) {
        [vc didMoveToParentViewController:self];
    }
}

- (void)setControllers:(NSArray <UIViewController <Paginationable>*>*)controllers {
    
    _controllers = controllers;
    
    if (self.viewWasShowed) {
        [self addControllersToScroll];
    }
}

#pragma makr - Public Methods

-(void)scrollToIndex:(NSInteger)index animated:(BOOL)animated{
    
    if (index < 0 || index >= self.controllers.count) {
        return;
    }

    [self.scrollView scrollRectToVisible:CGRectMake(index * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height) animated:animated];
    [self changeCurrentIndex:index];
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
    
    self.enabledScroll = enable;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scrollView.scrollEnabled = enable;
    });
}

- (void)setPageControllHidden:(BOOL) hidden {
    DLog("This method must to be overridden");
}

#pragma mark - Private Methods

- (void)changeCurrentIndex:(NSInteger)index {
    self.currentIndex = index;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if ((NSInteger)scrollView.contentOffset.x % (NSInteger)scrollView.bounds.size.width == 0) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self changeCurrentIndex:index];
    }
}

@end
