//
//  Gradient.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "GradientLayer.h"

@interface GradientLayer ()

@property (assign, nonatomic) CGPoint center;
@property (assign, nonatomic) CGSize size;

@end

@implementation GradientLayer

- (instancetype)initWithCenter:(CGPoint) center andSize:(CGSize) size {
	self = [super init];
	if (self) {
		_center = center;
		_size = size;
		self.masksToBounds = NO;
		[self setNeedsDisplay];
	}
	return self;
}

- (void)drawInContext:(CGContextRef) ctx {
	size_t gradLocationsNum = 2;
	CGFloat gradLocations[2] = {0.0f, 1.0f};
	CGFloat gradColors[8] = {1.0f, 1.0f, 1.0f, 0.07f, 1.0f, 1.0f, 1.0f, 0.0f};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorSpace, gradColors, gradLocations, gradLocationsNum);
	CGColorSpaceRelease (colorSpace);

	CGPoint gradCenter = self.center;
	float gradRadius = MIN(self.size.width, self.size.height);

	CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsBeforeStartLocation);
	CGGradientRelease (gradient);
}

@end
