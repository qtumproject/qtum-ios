//
//  GradientView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "iMessageGradientView.h"

@interface iMessageGradientView ()

@property (nonatomic) CAGradientLayer *gradientLayer;
@property (strong, nonatomic) UIColor* fromColor;
@property (strong, nonatomic) UIColor* toColor;

@end

@implementation iMessageGradientView

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
    if (self.colorType == Pink) {
        gradient.colors = @[(id)[[UIColor colorWithRed:230/255.0f green:168/255.0f blue:178/255.0f alpha:1.0f] CGColor],
                            (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
    } else if(self.colorType == Blue){
        gradient.colors = @[(id)[[UIColor colorWithRed:63/255.0f green:56/255.0f blue:196/255.0f alpha:1.0f] CGColor],
                            (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
    } else {
        gradient.colors = @[(id)[[UIColor colorWithRed:83/255.0f green:205/255.0f blue:127/255.0f alpha:1.0f] CGColor],
                            (id)[[UIColor colorWithRed:56/255.0f green:176/255.0f blue:197/255.0f alpha:1.0f] CGColor]];
    }
}

@end
