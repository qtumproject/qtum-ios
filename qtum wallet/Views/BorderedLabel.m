//
//  BorderedLabel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 23.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "BorderedLabel.h"

@implementation BorderedLabel

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self configBorder];
    }
    return self;
}

-(void)configBorder{
    self.layer.borderColor = [UIColor colorWithRed:46/255. green:154/255. blue:208/255. alpha:1].CGColor;
    self.layer.borderWidth = 1;
}

- (void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
