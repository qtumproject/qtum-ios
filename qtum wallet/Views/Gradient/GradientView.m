//
//  GradientView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
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
    
    switch (self.colorType) {
        case Pink:
            gradient.colors = @[(id)[[UIColor colorWithRed:255/255.0f green:121/255.0f blue:103/255.0f alpha:1.0f] CGColor],
                                (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
            break;
        case Blue:
            gradient.colors = @[(id)[[UIColor colorWithRed:63/255.0f green:56/255.0f blue:196/255.0f alpha:1.0f] CGColor],
                                (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
            break;
        case Green:
            gradient.colors = @[(id)[[UIColor colorWithRed:83/255.0f green:205/255.0f blue:163/255.0f alpha:1.0f] CGColor],
                                (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
            break;
        case ForWallet:
            gradient.colors = @[(id)[[UIColor colorWithRed:62/255.0f green:67/255.0f blue:196/255.0f alpha:1.0f] CGColor],
                                (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
            break;
        case White:
            gradient.colors = @[(id)[[UIColor colorWithWhite:1 alpha:0] CGColor],
                                (id)[[UIColor whiteColor] CGColor]];
            break;
        default:
            break;
    }
}

@end
