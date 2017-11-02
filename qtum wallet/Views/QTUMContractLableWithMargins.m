//
//  QTUMContractLableWithMargins.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMContractLableWithMargins.h"

@interface QTUMContractLableWithMargins ()

@property (assign, nonatomic) UIEdgeInsets insets;

@end

@implementation QTUMContractLableWithMargins

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.insets = UIEdgeInsetsMake(0, 4, 0, 4);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (CGSize)intrinsicContentSize {
    
    CGSize size = [super intrinsicContentSize];
    size.width  += self.insets.left + self.insets.right;
    size.height += self.insets.top + self.insets.bottom;
    return size;
}

@end
