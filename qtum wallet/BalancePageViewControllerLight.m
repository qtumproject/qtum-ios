//
//  BalancePageViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BalancePageViewControllerLight.h"
#import "PageControlLight.h"
#import "GradientView.h"

@interface BalancePageViewControllerLight ()

@property (nonatomic) GradientView *gradientView;
@property (nonatomic) PageControlLight *pageControl;

@end

@implementation BalancePageViewControllerLight

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gradientView = [GradientView new];
    self.gradientView.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientView.colorType = White;
    [self.view addSubview:self.gradientView];
    [self setupConstraintsForGradient];
    
    self.pageControl = [PageControlLight new];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.gradientView addSubview:self.pageControl];
    [self setupConstraintsForPageControl];
    [self.pageControl setPagesCount:self.controllers.count];
}

- (void)setupConstraintsForGradient {
    
    NSDictionary *view = @{@"gradient" : self.gradientView};
    NSArray *widthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[gradient]-0-|" options:0 metrics:nil views:view];
    NSArray *heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradient(35)]-0-|" options:0 metrics:nil views:view];
    
    [self.view addConstraints:widthConstraints];
    [self.view addConstraints:heightConstraints];
}

- (void)setupConstraintsForPageControl {
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:9.0f];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.gradientView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.gradientView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-6.0f];
    
    [self.pageControl addConstraint:height];
    [self.gradientView addConstraint:centerX];
    [self.gradientView addConstraint:bottom];
}

- (void)setControllers:(NSArray<UIViewController<Paginationable> *> *)controllers {
    
    [super setControllers:controllers];
    
    [self.pageControl setPagesCount:controllers.count];
    [self.pageControl setSelectedPage:self.currentIndex];
}

- (void)changeCurrentIndex:(NSInteger)index {
    
    [super changeCurrentIndex:index];
    
    [self.pageControl setSelectedPage:index];
}

-(void)setPageControllHidden:(BOOL) hidden {
    self.pageControl.hidden = hidden;
}

@end
