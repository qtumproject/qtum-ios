//
//  BorderedLabel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "BorderedLabel.h"

@interface BorderedLabel()

@property (nonatomic) UIView *borderView;

@end

@implementation BorderedLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configBorder];
    }
    return self;
}

- (void)layoutSubviews {
    
    [self createAndAddConstraints];
    [super layoutSubviews];
    [self.superview layoutIfNeeded];
    NSLog(@"%@", self.borderView);
}

-(void)configBorder{
    
    self.borderView = [self getBorderView];
    self.borderView.translatesAutoresizingMaskIntoConstraints = NO;
    self.borderView.backgroundColor = [self getBackroundColor];
    self.borderView.layer.borderColor = [self getBorderColor].CGColor;
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.cornerRadius = 2;
    self.borderView.layer.masksToBounds = YES;
}

- (void)createAndAddConstraints {
    
    if (self.borderView.superview) {
        return;
    }
    
    [self.superview insertSubview:self.borderView atIndex:0];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.borderView attribute:NSLayoutAttributeTop multiplier:1.0f constant:[self getInsets]];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.borderView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:[self getInsets]];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.borderView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-[self getInsets]];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.borderView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-[self getInsets] - 2.0f];
    
    [self.superview addConstraints:@[top, left, right, bottom]];
}

#pragma mark - Public

- (UIColor *)getBorderColor {
    return customBlueColor();
}

- (UIColor *)getBackroundColor{
    return [UIColor clearColor];
}

- (UIView *)getBorderView {
    return [UIView new];
}

- (CGFloat)getInsets {
    return 14.0f;
}

@end
