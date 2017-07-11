//
//  BorderedLabelDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BorderedLabelDark.h"

@implementation BorderedLabelDark

- (UIColor *)getBorderColor {
    return customBlueColor();
}

- (UIColor *)getBackroundColor{
    return [UIColor clearColor];
}

- (UIView *)getBorderView {
    return [UIView new];
}

- (CGFloat)getInsets {
    return 7.0f;
}

@end
