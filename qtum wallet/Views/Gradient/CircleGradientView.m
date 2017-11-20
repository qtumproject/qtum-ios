//
//  CircleGradientView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "CircleGradientView.h"

@interface CircleGradientView ()

@property (nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation CircleGradientView

- (void)drawRect:(CGRect)rect
{
    [super layoutSubviews];
    
    // Setup view
    CGFloat colorComponents[] = {239/255.0f, 246/255.0f, 249/255.0f, 1.0,   // First color:  R, G, B, ALPHA (currently opaque black)
                                216/255.0f, 233/255.0f, 241/255.0f, 1.0};  // Second color: R, G, B, ALPHA (currently transparent black)
    CGFloat locations[] = {0, 1}; // {0, 1) -> from center to outer edges, {1, 0} -> from outer edges to center
    CGFloat radius = MIN((self.bounds.size.height / 2), (self.bounds.size.width / 2));
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    // Prepare a context and create a color space
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create gradient object from our color space, color components and locations
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);
    
    // Draw a gradient
    CGContextDrawRadialGradient(context, gradient, center, 0.0, center, radius, 0);
    CGContextRestoreGState(context);
    
    // Release objects
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
