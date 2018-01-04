//
//  ResetButtonFromConfirmBK.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ResetButtonFromConfirmBK.h"

@implementation ResetButtonFromConfirmBK

static NSInteger cornerRadius = 12;
static NSInteger borderWidth = 2;
static NSInteger smallCornerRadius = 2;

-(void)drawRect:(CGRect)rect {
    
    UIBezierPath* borderPath = [[UIBezierPath alloc] init];
    
    [borderPath moveToPoint:CGPointMake(0 + borderWidth , cornerRadius + borderWidth)];
    [borderPath addArcWithCenter:CGPointMake(cornerRadius + borderWidth, cornerRadius + borderWidth) radius:cornerRadius startAngle: 180 * M_PI / 180.0 endAngle:270 * M_PI / 180.0 clockwise:YES];
    [borderPath addLineToPoint:CGPointMake(rect.size.width - borderWidth / 2, 0 + borderWidth)];
    [borderPath addLineToPoint:CGPointMake(rect.size.width - borderWidth / 2, rect.size.height - smallCornerRadius)];
    [borderPath addArcWithCenter:CGPointMake(rect.size.width - smallCornerRadius, rect.size.height - smallCornerRadius - borderWidth / 2) radius:smallCornerRadius startAngle: 0 * M_PI / 180.0 endAngle:90 * M_PI / 180.0 clockwise:YES];
    [borderPath addLineToPoint:CGPointMake(0 + borderWidth, rect.size.height - borderWidth / 2)];
    [borderPath addLineToPoint:CGPointMake(0 + borderWidth, cornerRadius + borderWidth)];
    
    [[UIColor colorWithRed:220/255. green:223/255. blue:226/255. alpha:1] setStroke];
    [[UIColor whiteColor] setFill];
    
    borderPath.lineWidth = borderWidth;
    
    [borderPath stroke];
    [borderPath fill];
    [borderPath closePath];
}

@end
