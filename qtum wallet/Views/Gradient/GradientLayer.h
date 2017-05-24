//
//  Gradient.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GradientLayer : CALayer

- (instancetype)initWithCenter:(CGPoint) center andSize:(CGSize)size;

@end
