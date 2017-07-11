//
//  BorderedLabelLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BorderedLabelLight.h"
#import "InnerShadowView.h"

@interface BorderedLabelLight()

@property (nonatomic) CALayer *shadowLayer;

@end

@implementation BorderedLabelLight

- (UIColor *)getBorderColor {
    return [lightBlackColor78() colorWithAlphaComponent:0.2f];
}

- (UIColor *)getBackroundColorForShadow {
    return lightBorderLabelBackroundColor();
}

- (void)drawRect:(CGRect)rect {
    
    self.borderView.frame = CGRectMake(-7.0f, -7.0f, self.frame.size.width + 14.0f, self.frame.size.height + 16.0f);
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: [UIColor.blackColor colorWithAlphaComponent: 0.43]];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 5];
    
    //// Rectangle Drawing
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect:self.borderView.frame cornerRadius:2.0f];
    [[self getBackroundColorForShadow] setFill];
    [rectanglePath fill];
    
    ////// Rectangle Inner Shadow
    CGContextSaveGState(context);
    UIRectClip(rectanglePath.bounds);
    CGContextSetShadowWithColor(context, CGSizeZero, 0, NULL);
    
    CGContextSetAlpha(context, CGColorGetAlpha([shadow.shadowColor CGColor]));
    CGContextBeginTransparencyLayer(context, NULL);
    {
        UIColor* opaqueShadow = [shadow.shadowColor colorWithAlphaComponent: 1];
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [opaqueShadow CGColor]);
        CGContextSetBlendMode(context, kCGBlendModeSourceOut);
        CGContextBeginTransparencyLayer(context, NULL);
        
        [opaqueShadow setFill];
        [rectanglePath fill];
        
        CGContextEndTransparencyLayer(context);
    }
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    [super drawRect:rect];
}

@end
