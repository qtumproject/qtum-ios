//
//  SpinnerView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SpinnerView.h"

CGFloat BorderWidth = 4.0f;
CGFloat SpinAnimationDuration = 0.6f;
CGFloat ContentAnimationDuration = 1.0f;
NSString *RotationAnimationKey = @"rotationAnimation";

@interface SpinnerView () <CAAnimationDelegate>

@property (nonatomic) UIView *smallView;
@property (nonatomic) UIView *centerView;
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) CGFloat angle;

@end

@implementation SpinnerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    CGFloat sizeForCenterView = [self calculateValueHypotenuse:self.frame.size.width];
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - sizeForCenterView) / 2.0f,
                                                               (self.frame.size.height - sizeForCenterView) / 2.0f,
                                                               sizeForCenterView,
                                                               sizeForCenterView)];
    
    self.centerView.layer.borderColor = self.tintColor.CGColor;
    self.centerView.layer.borderWidth = BorderWidth;
    self.centerView.backgroundColor = [UIColor clearColor];
    self.centerView.clipsToBounds = YES;
    [self addSubview:self.centerView];
    
    self.smallView = [[UIView alloc] initWithFrame:CGRectMake(0, self.centerView.frame.size.height,
                                                             self.centerView.frame.size.width,
                                                              0.0f)];
    self.smallView.backgroundColor = self.tintColor;
    [self.centerView addSubview:self.smallView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.isAnimating) {
        [self startSpinAnimationOnView];
        self.isAnimating = YES;
    }
}

#pragma mark - Public methods

- (BOOL)animating {
    return self.isAnimating;
}

- (void)startAnimating {
    
    if (self.isAnimating) {
        return;
    }
    
    self.isAnimating = YES;
    [self clearFrames];
    [self startSpinAnimationOnView];
}

- (void)stopAnimating {
    
    if (!self.isAnimating) {
        return;
    }
    
    self.isAnimating = false;
    [self.centerView.layer removeAllAnimations];
    self.angle = 0.0f;
    
    [self clearFrames];
}

#pragma mark - Private methods

- (void)clearFrames {
    CGFloat sizeForCenterView = [self calculateValueHypotenuse:self.frame.size.width];
    self.centerView.frame = CGRectMake((self.frame.size.width - sizeForCenterView) / 2.0f,
                                       (self.frame.size.height - sizeForCenterView) / 2.0f,
                                       sizeForCenterView,
                                       sizeForCenterView);
    self.smallView.frame = CGRectMake(0, self.centerView.frame.size.height,
                                      self.centerView.frame.size.width,
                                      0.0f);
}

- (void)startSpinAnimationOnView {
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = @(self.angle);
    self.angle += M_PI;
    rotationAnimation.toValue = @(self.angle);
    rotationAnimation.duration = SpinAnimationDuration;
    rotationAnimation.delegate = self;
    rotationAnimation.removedOnCompletion = YES;
    
    [self.centerView.layer addAnimation:rotationAnimation forKey:RotationAnimationKey];
}

- (void)startContentAnimation {
    
    CGFloat height = (self.smallView.frame.size.height == 0.0f) ? self.centerView.frame.size.height : 0.0f;
    CGFloat yPosition = (self.smallView.frame.size.height == 0.0f) ? self.centerView.frame.size.height : 0.0f;
    self.smallView.frame = CGRectMake(0, yPosition, self.smallView.frame.size.width, self.smallView.frame.size.height);
    
    [UIView animateWithDuration:ContentAnimationDuration animations:^{
        self.smallView.frame = CGRectMake(0.0f, 0.0f, self.smallView.frame.size.width, height);
    } completion:^(BOOL finished) {
        if (finished && self.isAnimating) {
            [self startSpinAnimationOnView];
        } else {
            self.isAnimating = NO;
        }
    }];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && self.isAnimating) {
        [self startContentAnimation];
    } else {
        self.isAnimating = NO;
    }
}

#pragma mark - Math

- (CGFloat)calculateHypotenuse:(CGFloat)value {
    double width = [@(value) doubleValue];
    return [@(sqrt(pow(width, 2) * 2)) floatValue];
}

- (CGFloat)calculateValueHypotenuse:(CGFloat)hypotenuse {
    double hip = [@(hypotenuse) doubleValue];
    return [@(sqrt(pow(hip, 2) / 2.0f)) floatValue];
}

@end
