//
//  SpinnerViewLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SpinnerViewLight.h"

@interface SpinnerViewLight ()

@property (strong, nonatomic) UIImageView* loaderImage;
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation SpinnerViewLight

- (void)setup {
        
    UIImageView* loaderImage = [[UIImageView alloc] initWithFrame:self.bounds];
    loaderImage.image = [UIImage imageNamed:@"ic-loader-light"];
    loaderImage.tintColor = self.tintColor;
    loaderImage.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.loaderImage = loaderImage;
    [self addSubview:loaderImage];
}

- (void)layoutSubviews {
    
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
    [self startSpinAnimationOnView];
}

- (void)stopAnimating {
    
    if (!self.isAnimating) {
        return;
    }
    
    self.isAnimating = NO;
    [self clearFrames];
}

#pragma mark - Private methods

- (void)clearFrames {

}

- (void)startSpinAnimationOnView {
    
    CGFloat duration = 1;
    [self runSpinAnimationOnView:self.loaderImage duration:duration rotations:1 repeat:YES];
}

#pragma mark - Math

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(BOOL)repeat {
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


@end
