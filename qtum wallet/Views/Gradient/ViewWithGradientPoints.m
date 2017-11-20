//
//  ImageVithGradients.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "ViewWithGradientPoints.h"
#import "GradientLayer.h"

@implementation ViewWithGradientPoints

- (void)drawRect:(CGRect)rect {
    [self addGradientAtPoint:CGPointMake(68, 59) andSize:CGSizeMake(20, 20)];
    [self addGradientAtPoint:CGPointMake(24, 32) andSize:CGSizeMake(15, 15)];
    [self addGradientAtPoint:CGPointMake(7, 50) andSize:CGSizeMake(15, 15)];
}

-(void)addGradientAtPoint:(CGPoint) point andSize:(CGSize)size {
    //меняем фрем с учетом приближения точки к грацице вью
    CGPoint pointWithOffset = CGPointMake(point.x + size.width, point.y + size.height);
    GradientLayer *gradientLayer = [[GradientLayer alloc] initWithCenter:pointWithOffset andSize:size];
    gradientLayer.frame = CGRectMake(- size.width, - size.height, self.frame.size.width + size.width * 2, self.frame.size.height + size.height * 2);
    [self.layer addSublayer:gradientLayer];
}

@end
