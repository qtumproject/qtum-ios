//
//  BalanceTokenView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BalanceTokenView.h"

@implementation BalanceTokenView

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize size = [self.balanceValueLabel.text sizeWithAttributes:@{NSFontAttributeName : self.balanceValueLabel.font}];
    if (size.width > self.balanceValueLabel.bounds.size.width) {
        self.balanceValueLabel.text = self.shortBalance;
    }
}

@end
