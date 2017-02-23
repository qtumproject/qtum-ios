//
//  GradientView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@property (nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation GradientView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CAGradientLayer *gradient;
    if (self.gradientLayer) {
        gradient = self.gradientLayer;
    }else{
        gradient = [CAGradientLayer layer];
        [self.layer insertSublayer:gradient atIndex:0];
        self.layer.masksToBounds = YES;
        
        self.gradientLayer = gradient;
    }
    
    gradient.frame = self.bounds;
    gradient.colors = @[(id)[[UIColor colorWithRed:63/255.0f green:56/255.0f blue:196/255.0f alpha:1.0f] CGColor],
                        (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
}

@end
