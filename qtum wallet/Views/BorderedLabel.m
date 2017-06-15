//
//  BorderedLabel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "BorderedLabel.h"

@interface BorderedLabel()

@property (nonatomic) UIView *borderView;

@end

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
    self.borderView = [UIView new];
    self.borderView.backgroundColor = [UIColor clearColor];
    self.borderView.layer.borderColor = [UIColor colorWithRed:46/255. green:154/255. blue:208/255. alpha:1].CGColor;
    self.borderView.layer.borderWidth = 1;
    [self addSubview:self.borderView];
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    self.borderView.frame = CGRectMake(-7.0f, -7.0f, self.frame.size.width + 14.0f, self.frame.size.height + 16.0f);
}



@end
