//
//  AnimatedLogoImageVIew.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AnimatedLogoImageVIew.h"

float const RedColorValue = 231.0f;
float const GreenColorValue = 86.0f;
float const BlueColorValue = 71.0f;
float const OneTickAnimationTime = 2.0f;

@interface AnimatedLogoImageVIew()


@end

@implementation AnimatedLogoImageVIew

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.image = [self.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _needRepeate = YES;
        _animationTime = OneTickAnimationTime;
        [self setTintColor:self.tintColor];
    }
    return self;
}

- (void)layoutSubviews {
    
    if (self.secondImageView == nil) {
        
        self.secondImageView = [[UIImageView alloc] initWithImage:self.image];
        self.secondImageView.contentMode = UIViewContentModeBottom;
        self.secondImageView.clipsToBounds = YES;
        self.secondImageView.hidden = YES;
        self.secondImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.secondImageView setTintColor:[UIColor colorWithRed:RedColorValue/255.f green:GreenColorValue/255.f blue:BlueColorValue/255.f alpha:1.0f]];
        [self addSubview:self.secondImageView];
        [self setNeedsUpdateConstraints];
    }
    
    [super layoutSubviews];
}

- (void)updateConstraints {
    
    if (self.needsUpdateConstraints) {
        [self addConstraintsToSecondImage];
    }
    
    [super updateConstraints];
}

- (void)addConstraintsToSecondImage {
    
    if (self.secondImageView == nil) return;
    if (self.topConstraintForSecondImageView != nil) return;
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0f
                                                                      constant:self.frame.size.height];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:0.0f];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0f
                                                                          constant:0.0f];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
                                                                          attribute:NSLayoutAttributeTrailing
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self
                                                                          attribute:NSLayoutAttributeTrailing
                                                                         multiplier:1.0f
                                                                           constant:0.0f];
    
    [self addConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];
    
    self.topConstraintForSecondImageView = topConstraint;
}

- (void)startAnimating
{
    if (self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    self.secondImageView.hidden = NO;
    self.topConstraintForSecondImageView.constant = self.frame.size.height;
    
    [self oneTickAnimation];
}

- (void)stopAnimating {
    
    self.isAnimating = NO;
    self.secondImageView.hidden = YES;
    
    [self.layer removeAllAnimations];
}

- (void)oneTickAnimation {
    
    if (!self.isAnimating) {
        self.topConstraintForSecondImageView.constant = self.frame.size.height;
        return;
    }
    
    self.topConstraintForSecondImageView.constant = 0.0f;
    [UIView animateWithDuration:self.animationTime delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.isAnimating && finished && self.needRepeate) {
            self.topConstraintForSecondImageView.constant = self.frame.size.height;
            [self layoutIfNeeded];
            [self oneTickAnimation];
        }
    }];
}

@end
