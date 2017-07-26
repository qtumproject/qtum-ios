//
//  InputTextView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "InputTextView.h"

@interface InputTextView ()

@property (nonatomic) UIView *borderView;

@end

@implementation InputTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Config

-(void)config {
    self.layer.borderColor = [UIColor colorWithRed:46/255. green:154/255. blue:208/255. alpha:1].CGColor;
    self.layer.borderWidth = 1;
    self.textContainerInset = UIEdgeInsetsMake(6, 4, 6, 4);
}


@end
