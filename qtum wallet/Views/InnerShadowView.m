//
//  InnerShadowView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "InnerShadowView.h"

@implementation InnerShadowView

- (void)drawRect:(CGRect) rect {

	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext ();

	//// Shadow Declarations
	NSShadow *shadow = [[NSShadow alloc] init];
	[shadow setShadowColor:[UIColor.blackColor colorWithAlphaComponent:0.2]];
	[shadow setShadowOffset:CGSizeMake (0.1, -0.1)];
	[shadow setShadowBlurRadius:4];

	//// Rectangle Drawing
	UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:self.layer.cornerRadius];
	[[UIColor clearColor] setFill];
	[rectanglePath fill];

	////// Rectangle Inner Shadow
	CGContextSaveGState (context);
	UIRectClip (rectanglePath.bounds);
	CGContextSetShadowWithColor (context, CGSizeZero, 0, NULL);

	CGContextSetAlpha (context, CGColorGetAlpha ([shadow.shadowColor CGColor]));
	CGContextBeginTransparencyLayer (context, NULL);
	{
		UIColor *opaqueShadow = [shadow.shadowColor colorWithAlphaComponent:1];
		CGContextSetShadowWithColor (context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
		CGContextSetBlendMode (context, kCGBlendModeSourceOut);
		CGContextBeginTransparencyLayer (context, NULL);

		[opaqueShadow setFill];
		[rectanglePath fill];

		CGContextEndTransparencyLayer (context);
	}
	CGContextEndTransparencyLayer (context);
	CGContextRestoreGState (context);

	[super drawRect:rect];
}

@end
