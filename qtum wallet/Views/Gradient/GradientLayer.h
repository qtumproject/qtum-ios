//
//  Gradient.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GradientLayer : CALayer

- (instancetype)initWithCenter:(CGPoint) center andSize:(CGSize)size;

@end
