//
//  ImputTextView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ImputTextView.h"

@interface ImputTextView ()

@end

@implementation ImputTextView

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configBorder];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}

#pragma makr - Config

-(void)configBorder{
    self.layer.borderColor = [UIColor colorWithRed:46/255. green:154/255. blue:208/255. alpha:1].CGColor;
    self.layer.borderWidth = 1;
}

#pragma mark - Drawing

//- (void)drawRect:(CGRect)rect {
//}

@end
