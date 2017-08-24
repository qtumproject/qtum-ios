//
//  DiagramView.m
//  DiagramAnimation
//
//  Created by Vladimir Lebedevich on 29.12.16.
//  Copyright © 2016 com.example. All rights reserved.
//

#import "DiagramView.h"

@interface DiagramView () <CAAnimationDelegate>

@property (strong, nonatomic)CAShapeLayer* animationLayer;
@property (strong, nonatomic)NSArray <UIBezierPath *>* arrayOfPaths;
@property (assign, nonatomic)BOOL animating;
@property (assign, nonatomic) CGRect animationRect;

@end

@implementation DiagramView

-(void)drawRect:(CGRect)rect {
    self.animationLayer.path = self.arrayOfPaths[0].CGPath;
    if (!self.animating) {
        [self startAmimate];
    }
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
        [self subscribeNotifications];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self subscribeNotifications];
    }
    return self;
}

#pragma mark - Setup

-(void)setup{
    self.layer.masksToBounds = YES;
    self.animationLayer = [CAShapeLayer new];
    self.animationLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.07].CGColor;
    [self.layer addSublayer:self.animationLayer];
}

#pragma mark - Getter/Setter

-(NSArray<UIBezierPath *> *)arrayOfPaths{
    if (!_arrayOfPaths) {
        if (!self.isSmall) {
            _arrayOfPaths = @[[self pathOne],[self pathTwo],[self pathThree],[self pathFour],[self pathFive]];
        }else {
            _arrayOfPaths= @[[self pathOneSmall],[self pathTwoSmall],[self pathThreeSmall],[self pathFourSmall],[self pathFiveSmall]];
        }
    }
    return _arrayOfPaths;
}

#pragma mark - Subscribs

-(void)subscribeNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    self.animating = NO;
}

//-(void)removeFromSuperview{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super removeFromSuperview];
//}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    if (!flag) {
        self.animating = NO;
    }
}


#pragma mark - Private Methods

-(void)startAmimate {
    if (self.animating && self.animationRect.size.height == self.bounds.size.height) {
        return;
    }
    [self.animationLayer removeAllAnimations];
    
    self.animating = YES;
    self.animationRect = self.bounds;
    
    CAKeyframeAnimation *customFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    NSArray *pathValues = @[(id)self.arrayOfPaths[0].CGPath,(id)self.arrayOfPaths[1].CGPath,(id)self.arrayOfPaths[2].CGPath,(id)self.arrayOfPaths[3].CGPath,(id)self.arrayOfPaths[4].CGPath];
    NSArray *times = @[@0.0,@0.25,@0.45,@0.68,@1];
   // NSArray* timming = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

    [customFrameAnimation setValues:pathValues];
    [customFrameAnimation setKeyTimes:times];
   // [customFrameAnimation setTimingFunctions:timming];
    customFrameAnimation.repeatCount = HUGE_VALF;
    customFrameAnimation.duration = 10;
    customFrameAnimation.delegate = self;
    [self.animationLayer addAnimation:customFrameAnimation forKey:@"Animation key"];
}

-(UIBezierPath*)pathOne{
    CGRect frame = self.bounds;
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-3, 254.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 9.03, CGRectGetMinY(frame) + 186.5) controlPoint1: CGPointMake(0.29, 254.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 19.15, CGRectGetMinY(frame) + 198)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 31.08, CGRectGetMinY(frame) + 177.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 25.46, CGRectGetMinY(frame) + 161.61)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.5, CGRectGetMinY(frame) + 186.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 82.5, CGRectGetMinY(frame) + 155.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 67.77, CGRectGetMinY(frame) + 186.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 191.5, CGRectGetMinY(frame) + 140.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.5, CGRectGetMinY(frame) + 186.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 156.21, CGRectGetMinY(frame) + 136.97)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 250.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 211.5, CGRectGetMinY(frame) + 142.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 238.05, CGRectGetMinY(frame) + 161.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 360.5, CGRectGetMinY(frame) + 113.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 281.57, CGRectGetMinY(frame) + 150.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 309.4, CGRectGetMinY(frame) + 69.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 421.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 401.5, CGRectGetMinY(frame) + 148.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 409.25, CGRectGetMinY(frame) + 159)];
    [bezier3Path addCurveToPoint: CGPointMake(519.5, 129.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 470.5, CGRectGetMinY(frame) + 156.5) controlPoint2: CGPointMake(449.54, 70.58)];
    [bezier3Path addCurveToPoint: CGPointMake(600.5, 93.5) controlPoint1: CGPointMake(538.5, 145.5) controlPoint2: CGPointMake(580.5, 85.5)];
    [bezier3Path addCurveToPoint: CGPointMake(666.5, 72.5) controlPoint1: CGPointMake(605.5, 95.5) controlPoint2: CGPointMake(640.48, 112.66)];
    [bezier3Path addCurveToPoint: CGPointMake(766.5, 129.5) controlPoint1: CGPointMake(712.5, 1.5) controlPoint2: CGPointMake(756, 131.75)];
    [bezier3Path addCurveToPoint: CGPointMake(866.5, 72.5) controlPoint1: CGPointMake(808.5, 120.5) controlPoint2: CGPointMake(827.5, 78.5)];
    [bezier3Path addCurveToPoint: CGPointMake(907.5, 141.5) controlPoint1: CGPointMake(893.83, 68.29) controlPoint2: CGPointMake(893.85, 142.47)];
    [bezier3Path addCurveToPoint: CGPointMake(946.5, 208.5) controlPoint1: CGPointMake(935.5, 139.5) controlPoint2: CGPointMake(929.77, 198.32)];
    [bezier3Path addCurveToPoint: CGPointMake(839.5, 254.5) controlPoint1: CGPointMake(992.5, 236.5) controlPoint2: CGPointMake(839.5, 254.5)];
    [bezier3Path addLineToPoint: CGPointMake(-3, 254.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathTwo{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-54, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-41.97, 188.5) controlPoint1: CGPointMake(-50.71, 255.29) controlPoint2: CGPointMake(-70.15, 200)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 159.5) controlPoint1: CGPointMake(-19.92, 179.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 25.54, CGRectGetMinY(frame) + 162.61)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 61.5, CGRectGetMinY(frame) + 174.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 31.5, CGRectGetMinY(frame) + 156.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 16.77, CGRectGetMinY(frame) + 174.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 140.5, CGRectGetMinY(frame) + 124.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 85.5, CGRectGetMinY(frame) + 174.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 105.21, CGRectGetMinY(frame) + 120.97)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 199.5, CGRectGetMinY(frame) + 176.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 160.5, CGRectGetMinY(frame) + 126.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 187.05, CGRectGetMinY(frame) + 179.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 309.5, CGRectGetMinY(frame) + 144.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 230.57, CGRectGetMinY(frame) + 168.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 258.4, CGRectGetMinY(frame) + 100.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 370.5, CGRectGetMinY(frame) + 131.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 350.5, CGRectGetMinY(frame) + 179.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 358.25, CGRectGetMinY(frame) + 132)];
    [bezier3Path addCurveToPoint: CGPointMake(468.5, 146.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 419.5, CGRectGetMinY(frame) + 129.5) controlPoint2: CGPointMake(398.54, 87.58)];
    [bezier3Path addCurveToPoint: CGPointMake(549.5, 94.5) controlPoint1: CGPointMake(487.5, 162.5) controlPoint2: CGPointMake(529.5, 86.5)];
    [bezier3Path addCurveToPoint: CGPointMake(615.5, 73.5) controlPoint1: CGPointMake(554.5, 96.5) controlPoint2: CGPointMake(589.48, 113.66)];
    [bezier3Path addCurveToPoint: CGPointMake(715.5, 130.5) controlPoint1: CGPointMake(661.5, 2.5) controlPoint2: CGPointMake(705, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(815.5, 73.5) controlPoint1: CGPointMake(757.5, 121.5) controlPoint2: CGPointMake(776.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(856.5, 142.5) controlPoint1: CGPointMake(842.83, 69.29) controlPoint2: CGPointMake(842.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(895.5, 209.5) controlPoint1: CGPointMake(884.5, 140.5) controlPoint2: CGPointMake(878.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(788.5, 255.5) controlPoint1: CGPointMake(941.5, 237.5) controlPoint2: CGPointMake(788.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-54, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathThree{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-105, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-92.97, 188.5) controlPoint1: CGPointMake(-101.71, 255.29) controlPoint2: CGPointMake(-121.15, 200)];
    [bezier3Path addCurveToPoint: CGPointMake(-47.5, 160.5) controlPoint1: CGPointMake(-70.92, 179.5) controlPoint2: CGPointMake(-76.54, 163.61)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 10.5, CGRectGetMinY(frame) + 170.5) controlPoint1: CGPointMake(-19.5, 157.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 34.23, CGRectGetMinY(frame) + 170.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 89.5, CGRectGetMinY(frame) + 119.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 34.5, CGRectGetMinY(frame) + 170.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 54.21, CGRectGetMinY(frame) + 115.97)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 148.5, CGRectGetMinY(frame) + 154.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 109.5, CGRectGetMinY(frame) + 121.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 136.05, CGRectGetMinY(frame) + 157.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 258.5, CGRectGetMinY(frame) + 106.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 179.57, CGRectGetMinY(frame) + 146.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 207.4, CGRectGetMinY(frame) + 62.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 319.5, CGRectGetMinY(frame) + 108.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 299.5, CGRectGetMinY(frame) + 141.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 307.25, CGRectGetMinY(frame) + 109)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 417.5, CGRectGetMinY(frame) + 113.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 368.5, CGRectGetMinY(frame) + 106.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 347.54, CGRectGetMinY(frame) + 54.58)];
    [bezier3Path addCurveToPoint: CGPointMake(498.5, 94.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 436.5, CGRectGetMinY(frame) + 129.5) controlPoint2: CGPointMake(478.5, 86.5)];
    [bezier3Path addCurveToPoint: CGPointMake(564.5, 73.5) controlPoint1: CGPointMake(503.5, 96.5) controlPoint2: CGPointMake(538.48, 113.66)];
    [bezier3Path addCurveToPoint: CGPointMake(664.5, 130.5) controlPoint1: CGPointMake(610.5, 2.5) controlPoint2: CGPointMake(654, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(764.5, 73.5) controlPoint1: CGPointMake(706.5, 121.5) controlPoint2: CGPointMake(725.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(805.5, 142.5) controlPoint1: CGPointMake(791.83, 69.29) controlPoint2: CGPointMake(791.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(844.5, 209.5) controlPoint1: CGPointMake(833.5, 140.5) controlPoint2: CGPointMake(827.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(737.5, 255.5) controlPoint1: CGPointMake(890.5, 237.5) controlPoint2: CGPointMake(737.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-105, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathFour{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-158, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-145.97, 188.5) controlPoint1: CGPointMake(-154.71, 255.29) controlPoint2: CGPointMake(-174.15, 200)];
    [bezier3Path addCurveToPoint: CGPointMake(-100.5, 160.5) controlPoint1: CGPointMake(-123.92, 179.5) controlPoint2: CGPointMake(-129.54, 163.61)];
    [bezier3Path addCurveToPoint: CGPointMake(-42.5, 171.5) controlPoint1: CGPointMake(-72.5, 157.5) controlPoint2: CGPointMake(-87.23, 171.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 36.5, CGRectGetMinY(frame) + 105.5) controlPoint1: CGPointMake(-18.5, 171.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 1.21, CGRectGetMinY(frame) + 101.97)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 95.5, CGRectGetMinY(frame) + 172.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 56.5, CGRectGetMinY(frame) + 107.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 83.05, CGRectGetMinY(frame) + 175.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 205.5, CGRectGetMinY(frame) + 91.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 126.57, CGRectGetMinY(frame) + 164.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 154.4, CGRectGetMinY(frame) + 47.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 266.5, CGRectGetMinY(frame) + 132.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 246.5, CGRectGetMinY(frame) + 126.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 254.25, CGRectGetMinY(frame) + 133)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 364.5, CGRectGetMinY(frame) + 135.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 315.5, CGRectGetMinY(frame) + 130.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 294.54, CGRectGetMinY(frame) + 76.58)];
    [bezier3Path addCurveToPoint: CGPointMake(445.5, 78.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 383.5, CGRectGetMinY(frame) + 151.5) controlPoint2: CGPointMake(425.5, 70.5)];
    [bezier3Path addCurveToPoint: CGPointMake(511.5, 73.5) controlPoint1: CGPointMake(450.5, 80.5) controlPoint2: CGPointMake(485.48, 113.66)];
    [bezier3Path addCurveToPoint: CGPointMake(611.5, 130.5) controlPoint1: CGPointMake(557.5, 2.5) controlPoint2: CGPointMake(601, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(711.5, 73.5) controlPoint1: CGPointMake(653.5, 121.5) controlPoint2: CGPointMake(672.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(752.5, 142.5) controlPoint1: CGPointMake(738.83, 69.29) controlPoint2: CGPointMake(738.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(791.5, 209.5) controlPoint1: CGPointMake(780.5, 140.5) controlPoint2: CGPointMake(774.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(684.5, 255.5) controlPoint1: CGPointMake(837.5, 237.5) controlPoint2: CGPointMake(684.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-158, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathFive{
    CGRect frame = self.bounds;
    
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-206, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-193.97, 188.5) controlPoint1: CGPointMake(-202.71, 255.29) controlPoint2: CGPointMake(-222.15, 200)];
    [bezier3Path addCurveToPoint: CGPointMake(-148.5, 160.5) controlPoint1: CGPointMake(-171.92, 179.5) controlPoint2: CGPointMake(-177.54, 163.61)];
    [bezier3Path addCurveToPoint: CGPointMake(-90.5, 171.5) controlPoint1: CGPointMake(-120.5, 157.5) controlPoint2: CGPointMake(-135.23, 171.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 9.03, CGRectGetMinY(frame) + 186.5) controlPoint1: CGPointMake(0.29, 254.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 19.15, CGRectGetMinY(frame) + 198)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 54.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 31.08, CGRectGetMinY(frame) + 177.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 25.46, CGRectGetMinY(frame) + 161.61)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.5, CGRectGetMinY(frame) + 186.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 82.5, CGRectGetMinY(frame) + 155.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 67.77, CGRectGetMinY(frame) + 186.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 191.5, CGRectGetMinY(frame) + 140.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 136.5, CGRectGetMinY(frame) + 186.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 156.21, CGRectGetMinY(frame) + 136.97)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 250.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 211.5, CGRectGetMinY(frame) + 142.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 238.05, CGRectGetMinY(frame) + 161.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 360.5, CGRectGetMinY(frame) + 113.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 281.57, CGRectGetMinY(frame) + 150.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 309.4, CGRectGetMinY(frame) + 69.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 421.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 401.5, CGRectGetMinY(frame) + 148.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 409.25, CGRectGetMinY(frame) + 159)];
    [bezier3Path addCurveToPoint: CGPointMake(563.5, 130.5) controlPoint1: CGPointMake(509.5, 20.5) controlPoint2: CGPointMake(553, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(663.5, 73.5) controlPoint1: CGPointMake(605.5, 121.5) controlPoint2: CGPointMake(624.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(704.5, 142.5) controlPoint1: CGPointMake(690.83, 69.29) controlPoint2: CGPointMake(690.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(743.5, 209.5) controlPoint1: CGPointMake(732.5, 140.5) controlPoint2: CGPointMake(726.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(636.5, 255.5) controlPoint1: CGPointMake(789.5, 237.5) controlPoint2: CGPointMake(636.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-206, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathOneSmall{
    CGRect frame = self.bounds;
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-292, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-280.5, 179.5) controlPoint1: CGPointMake(-288.71, 255.29) controlPoint2: CGPointMake(-308.68, 191)];
    [bezier3Path addCurveToPoint: CGPointMake(-232.5, 209.5) controlPoint1: CGPointMake(-258.45, 170.5) controlPoint2: CGPointMake(-261.54, 216.76)];
    [bezier3Path addCurveToPoint: CGPointMake(-179.5, 178.5) controlPoint1: CGPointMake(-204.5, 202.5) controlPoint2: CGPointMake(-207.46, 171.04)];
    [bezier3Path addCurveToPoint: CGPointMake(-120.5, 117.5) controlPoint1: CGPointMake(-164.5, 182.5) controlPoint2: CGPointMake(-146.97, 105.15)];
    [bezier3Path addCurveToPoint: CGPointMake(-61.5, 194.5) controlPoint1: CGPointMake(-105.5, 124.5) controlPoint2: CGPointMake(-73.95, 197.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.29, CGRectGetMinY(frame) + 254.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 16.68, CGRectGetMinY(frame) + 190)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 59.5, CGRectGetMinY(frame) + 208.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.55, CGRectGetMinY(frame) + 169.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 30.46, CGRectGetMinY(frame) + 215.76)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.5, CGRectGetMinY(frame) + 188.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 87.5, CGRectGetMinY(frame) + 201.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.54, CGRectGetMinY(frame) + 181.04)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 171.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 127.5, CGRectGetMinY(frame) + 192.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 145.03, CGRectGetMinY(frame) + 166.15)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 230.5, CGRectGetMinY(frame) + 153.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 186.5, CGRectGetMinY(frame) + 185.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 218.05, CGRectGetMinY(frame) + 156.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 305.5, CGRectGetMinY(frame) + 188.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 261.57, CGRectGetMinY(frame) + 145.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 279.33, CGRectGetMinY(frame) + 144.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 394.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 326.5, CGRectGetMinY(frame) + 223.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 375.25, CGRectGetMinY(frame) + 168.25)];
    [bezier3Path addCurveToPoint: CGPointMake(527.5, 189.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 471.5, CGRectGetMinY(frame) + 219.5) controlPoint2: CGPointMake(457.54, 130.58)];
    [bezier3Path addCurveToPoint: CGPointMake(657.5, 209.5) controlPoint1: CGPointMake(646.5, 140.5) controlPoint2: CGPointMake(640.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(550.5, 255.5) controlPoint1: CGPointMake(703.5, 237.5) controlPoint2: CGPointMake(550.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-292, 255.5)];

    return bezier3Path;
}

-(UIBezierPath*)pathTwoSmall{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-237, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-225.5, 179.5) controlPoint1: CGPointMake(-233.71, 255.29) controlPoint2: CGPointMake(-253.68, 191)];
    [bezier3Path addCurveToPoint: CGPointMake(-177.5, 209.5) controlPoint1: CGPointMake(-203.45, 170.5) controlPoint2: CGPointMake(-206.54, 216.76)];
    [bezier3Path addCurveToPoint: CGPointMake(-124.5, 178.5) controlPoint1: CGPointMake(-149.5, 202.5) controlPoint2: CGPointMake(-152.46, 171.04)];
    [bezier3Path addCurveToPoint: CGPointMake(-65.5, 117.5) controlPoint1: CGPointMake(-109.5, 182.5) controlPoint2: CGPointMake(-91.97, 105.15)];
    [bezier3Path addCurveToPoint: CGPointMake(-6.5, 194.5) controlPoint1: CGPointMake(-50.5, 124.5) controlPoint2: CGPointMake(-18.95, 197.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 68.5, CGRectGetMinY(frame) + 202.5) controlPoint1: CGPointMake(24.57, 186.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 42.33, CGRectGetMinY(frame) + 158.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 157.5, CGRectGetMinY(frame) + 193.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 89.5, CGRectGetMinY(frame) + 237.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 138.25, CGRectGetMinY(frame) + 183.25)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 290.5, CGRectGetMinY(frame) + 158.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 234.5, CGRectGetMinY(frame) + 234.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 220.54, CGRectGetMinY(frame) + 99.58)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 366.5, CGRectGetMinY(frame) + 107.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 309.5, CGRectGetMinY(frame) + 174.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 346.5, CGRectGetMinY(frame) + 99.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 432.5, CGRectGetMinY(frame) + 162.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 371.5, CGRectGetMinY(frame) + 109.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 406.48, CGRectGetMinY(frame) + 202.66)];
    [bezier3Path addCurveToPoint: CGPointMake(532.5, 130.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 478.5, CGRectGetMinY(frame) + 91.5) controlPoint2: CGPointMake(522, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(632.5, 73.5) controlPoint1: CGPointMake(574.5, 121.5) controlPoint2: CGPointMake(593.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(673.5, 142.5) controlPoint1: CGPointMake(659.83, 69.29) controlPoint2: CGPointMake(659.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(712.5, 209.5) controlPoint1: CGPointMake(701.5, 140.5) controlPoint2: CGPointMake(695.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(605.5, 255.5) controlPoint1: CGPointMake(758.5, 237.5) controlPoint2: CGPointMake(605.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-237, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathThreeSmall{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-150, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-138.5, 179.5) controlPoint1: CGPointMake(-146.71, 255.29) controlPoint2: CGPointMake(-166.68, 191)];
    [bezier3Path addCurveToPoint: CGPointMake(-90.5, 209.5) controlPoint1: CGPointMake(-116.45, 170.5) controlPoint2: CGPointMake(-119.54, 216.76)];
    [bezier3Path addCurveToPoint: CGPointMake(-37.5, 178.5) controlPoint1: CGPointMake(-62.5, 202.5) controlPoint2: CGPointMake(-65.46, 171.04)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 21.5, CGRectGetMinY(frame) + 116.5) controlPoint1: CGPointMake(-22.5, 182.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 4.97, CGRectGetMinY(frame) + 104.15)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 80.5, CGRectGetMinY(frame) + 193.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 36.5, CGRectGetMinY(frame) + 123.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 68.05, CGRectGetMinY(frame) + 196.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 155.5, CGRectGetMinY(frame) + 177.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 111.57, CGRectGetMinY(frame) + 185.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 129.33, CGRectGetMinY(frame) + 133.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 244.5, CGRectGetMinY(frame) + 174.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 176.5, CGRectGetMinY(frame) + 212.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 225.25, CGRectGetMinY(frame) + 164.25)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 377.5, CGRectGetMinY(frame) + 176.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 321.5, CGRectGetMinY(frame) + 215.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 307.54, CGRectGetMinY(frame) + 117.58)];
    [bezier3Path addCurveToPoint: CGPointMake(453.5, 133.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 396.5, CGRectGetMinY(frame) + 192.5) controlPoint2: CGPointMake(433.5, 125.5)];
    [bezier3Path addCurveToPoint: CGPointMake(519.5, 115.5) controlPoint1: CGPointMake(458.5, 135.5) controlPoint2: CGPointMake(493.48, 155.66)];
    [bezier3Path addCurveToPoint: CGPointMake(619.5, 130.5) controlPoint1: CGPointMake(565.5, 44.5) controlPoint2: CGPointMake(609, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(719.5, 73.5) controlPoint1: CGPointMake(661.5, 121.5) controlPoint2: CGPointMake(680.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(760.5, 142.5) controlPoint1: CGPointMake(746.83, 69.29) controlPoint2: CGPointMake(746.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(799.5, 209.5) controlPoint1: CGPointMake(788.5, 140.5) controlPoint2: CGPointMake(782.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(692.5, 255.5) controlPoint1: CGPointMake(845.5, 237.5) controlPoint2: CGPointMake(692.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-150, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathFourSmall{
    CGRect frame = self.bounds;
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(-75, 255.5)];
    [bezier3Path addCurveToPoint: CGPointMake(-63.5, 179.5) controlPoint1: CGPointMake(-71.71, 255.29) controlPoint2: CGPointMake(-91.68, 191)];
    [bezier3Path addCurveToPoint: CGPointMake(-15.5, 209.5) controlPoint1: CGPointMake(-41.45, 170.5) controlPoint2: CGPointMake(-44.54, 216.76)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 37.5, CGRectGetMinY(frame) + 177.5) controlPoint1: CGPointMake(12.5, 202.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 9.54, CGRectGetMinY(frame) + 170.04)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 96.5, CGRectGetMinY(frame) + 116.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 52.5, CGRectGetMinY(frame) + 181.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 70.03, CGRectGetMinY(frame) + 104.15)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 155.5, CGRectGetMinY(frame) + 167.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 111.5, CGRectGetMinY(frame) + 123.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 143.05, CGRectGetMinY(frame) + 170.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 230.5, CGRectGetMinY(frame) + 212.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 186.57, CGRectGetMinY(frame) + 159.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 204.33, CGRectGetMinY(frame) + 168.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 319.5, CGRectGetMinY(frame) + 164.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 251.5, CGRectGetMinY(frame) + 247.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 300.25, CGRectGetMinY(frame) + 154.25)];
    [bezier3Path addCurveToPoint: CGPointMake(452.5, 220.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 396.5, CGRectGetMinY(frame) + 205.5) controlPoint2: CGPointMake(382.54, 161.58)];
    [bezier3Path addCurveToPoint: CGPointMake(528.5, 133.5) controlPoint1: CGPointMake(471.5, 236.5) controlPoint2: CGPointMake(508.5, 125.5)];
    [bezier3Path addCurveToPoint: CGPointMake(594.5, 115.5) controlPoint1: CGPointMake(533.5, 135.5) controlPoint2: CGPointMake(568.48, 155.66)];
    [bezier3Path addCurveToPoint: CGPointMake(694.5, 130.5) controlPoint1: CGPointMake(640.5, 44.5) controlPoint2: CGPointMake(684, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(794.5, 73.5) controlPoint1: CGPointMake(736.5, 121.5) controlPoint2: CGPointMake(755.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(835.5, 142.5) controlPoint1: CGPointMake(821.83, 69.29) controlPoint2: CGPointMake(821.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(874.5, 209.5) controlPoint1: CGPointMake(863.5, 140.5) controlPoint2: CGPointMake(857.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(767.5, 255.5) controlPoint1: CGPointMake(920.5, 237.5) controlPoint2: CGPointMake(767.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(-75, 255.5)];
    return bezier3Path;
}

-(UIBezierPath*)pathFiveSmall{
    
    CGRect frame = self.bounds;
    //// Bezier 3 Drawing
    UIBezierPath* bezier3Path = [UIBezierPath bezierPath];
    [bezier3Path moveToPoint: CGPointMake(CGRectGetMinX(frame) + 0, CGRectGetMinY(frame) + 254.5)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 11.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 3.29, CGRectGetMinY(frame) + 254.29) controlPoint2: CGPointMake(CGRectGetMinX(frame) - 16.68, CGRectGetMinY(frame) + 190)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 59.5, CGRectGetMinY(frame) + 208.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 33.55, CGRectGetMinY(frame) + 169.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 30.46, CGRectGetMinY(frame) + 215.76)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 112.5, CGRectGetMinY(frame) + 188.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 87.5, CGRectGetMinY(frame) + 201.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 84.54, CGRectGetMinY(frame) + 181.04)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 171.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 127.5, CGRectGetMinY(frame) + 192.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 145.03, CGRectGetMinY(frame) + 166.15)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 230.5, CGRectGetMinY(frame) + 153.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 186.5, CGRectGetMinY(frame) + 185.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 218.05, CGRectGetMinY(frame) + 156.7)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 305.5, CGRectGetMinY(frame) + 188.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 261.57, CGRectGetMinY(frame) + 145.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 279.33, CGRectGetMinY(frame) + 144.88)];
    [bezier3Path addCurveToPoint: CGPointMake(CGRectGetMinX(frame) + 394.5, CGRectGetMinY(frame) + 178.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 326.5, CGRectGetMinY(frame) + 223.5) controlPoint2: CGPointMake(CGRectGetMinX(frame) + 375.25, CGRectGetMinY(frame) + 168.25)];
    [bezier3Path addCurveToPoint: CGPointMake(527.5, 189.5) controlPoint1: CGPointMake(CGRectGetMinX(frame) + 471.5, CGRectGetMinY(frame) + 219.5) controlPoint2: CGPointMake(457.54, 130.58)];
    [bezier3Path addCurveToPoint: CGPointMake(603.5, 133.5) controlPoint1: CGPointMake(546.5, 205.5) controlPoint2: CGPointMake(583.5, 125.5)];
    [bezier3Path addCurveToPoint: CGPointMake(669.5, 115.5) controlPoint1: CGPointMake(608.5, 135.5) controlPoint2: CGPointMake(643.48, 155.66)];
    [bezier3Path addCurveToPoint: CGPointMake(769.5, 130.5) controlPoint1: CGPointMake(715.5, 44.5) controlPoint2: CGPointMake(759, 132.75)];
    [bezier3Path addCurveToPoint: CGPointMake(869.5, 73.5) controlPoint1: CGPointMake(811.5, 121.5) controlPoint2: CGPointMake(830.5, 79.5)];
    [bezier3Path addCurveToPoint: CGPointMake(910.5, 142.5) controlPoint1: CGPointMake(896.83, 69.29) controlPoint2: CGPointMake(896.85, 143.47)];
    [bezier3Path addCurveToPoint: CGPointMake(949.5, 209.5) controlPoint1: CGPointMake(938.5, 140.5) controlPoint2: CGPointMake(932.77, 199.32)];
    [bezier3Path addCurveToPoint: CGPointMake(842.5, 255.5) controlPoint1: CGPointMake(995.5, 237.5) controlPoint2: CGPointMake(842.5, 255.5)];
    [bezier3Path addLineToPoint: CGPointMake(CGRectGetMinX(frame) + 0, CGRectGetMinY(frame) + 254.5)];
    return bezier3Path;
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
