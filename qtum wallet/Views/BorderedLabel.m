//
//  BorderedLabel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 23.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
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
    self.layer.borderColor = [UIColor colorWithRed:78/255. green:93/255. blue:111/255. alpha:0.2].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 2;

}

- (void)drawTextInRect:(CGRect)rect{
    UIEdgeInsets insets = {0, 10, 0, 10};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}


@end
