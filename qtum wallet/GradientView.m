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
    gradient.colors = @[(id)[[UIColor colorWithRed:93/255.0f green:194/255.0f blue:190/255.0f alpha:1.0f] CGColor],
                        (id)[[UIColor colorWithRed:126/255.0f green:196/255.0f blue:242/255.0f alpha:1.0f] CGColor]];
}

@end
