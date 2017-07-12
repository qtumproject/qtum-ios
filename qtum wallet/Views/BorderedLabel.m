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
    self.borderView.layer.borderColor = [self getBorderColor].CGColor;
    self.borderView.layer.borderWidth = 1;
    self.borderView.layer.cornerRadius = 2;
    self.borderView.layer.masksToBounds = YES;
    [self.layer insertSublayer:self.borderView.layer atIndex:0];
}

- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
//    self.borderView.frame = CGRectMake(-7.0f, -7.0f, self.frame.size.width + 14.0f, self.frame.size.height + 16.0f);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.borderView.frame = CGRectMake(-7.0f, -7.0f, self.frame.size.width + 14.0f, self.frame.size.height + 16.0f);
}

#pragma mark - Public

- (UIColor *)getBorderColor {
    return customBlueColor();
}

@end
