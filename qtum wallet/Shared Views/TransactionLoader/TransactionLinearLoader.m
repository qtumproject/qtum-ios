//
//  TransactionLinearLoader.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "TransactionLinearLoader.h"

@interface TransactionLinearLoader()

@property (nonatomic) CAShapeLayer *loaderShapeLayer;
@property (nonatomic) CGFloat lineWitdh;

@end

CGFloat const offset = 200;
CGFloat const loaderLineWidth = 4;
CGFloat const loaderHeight = 4;
CGFloat const animationDuration = 4;


@implementation TransactionLinearLoader

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = self.backColor;
        self.alpha = 0.0f;
        _lineWitdh = loaderLineWidth;
        [self createLoaderLayer];
    }
    return self;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWitdh = lineWidth;
}

- (void)createLoaderLayer {
    
    _loaderShapeLayer = [CAShapeLayer new];
    _loaderShapeLayer.masksToBounds = YES;
    _loaderShapeLayer.lineWidth = self.lineWitdh;
    _loaderShapeLayer.strokeColor = self.loaderColor.CGColor;
    _loaderShapeLayer.strokeEnd = 1.0f;
    _loaderShapeLayer.frame = self.bounds;
    [self.layer addSublayer:_loaderShapeLayer];
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    NSInteger startedPoint = -offset;
    self.loaderShapeLayer.frame = CGRectMake(startedPoint, self.bounds.size.height - loaderHeight, self.bounds.size.width * 2, loaderHeight);
    [self startAnimating];
}

- (void)startAnimating {
    
    self.alpha = 0.0f;
    
    [self startAnimatingLayers];
    
    [UIView animateWithDuration:1.0f animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)startAnimatingLayers {
    
    [self.loaderShapeLayer removeAllAnimations];
    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithCGPoint:_loaderShapeLayer.position]];
    CGPoint p = _loaderShapeLayer.position;
    p.x += offset;
    _loaderShapeLayer.position = p;
    [animation setRepeatCount:FLT_MAX];
    [animation setDuration:animationDuration];
    [animation setRemovedOnCompletion:NO];
    [_loaderShapeLayer addAnimation:animation forKey:@"toggleMenu"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self startAnimating];
    }
}

- (void)drawRect:(CGRect)rect {
    self.loaderShapeLayer.path = [self createPath:rect].CGPath;
}

- (UIBezierPath *)createPath:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath new];
    NSInteger linesCount = self.frame.size.width * 2 / loaderLineWidth;
    
    for (int i = 0; i < linesCount; i+= 2) {
        [path moveToPoint:CGPointMake(loaderLineWidth * (i + 1), - 1)];
        [path addLineToPoint:CGPointMake(loaderLineWidth * i, loaderHeight + 1)];
    }
    return path;
}

#pragma mark - Setters Colors

-(UIColor*)backColor {
    return [UIColor clearColor];
}

-(UIColor*)loaderColor {
    return [UIColor clearColor];
}

@end
