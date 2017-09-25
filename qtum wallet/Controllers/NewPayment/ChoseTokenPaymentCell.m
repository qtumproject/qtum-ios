//
//  ChoseTokenPaymentCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChoseTokenPaymentCell.h"

@implementation ChoseTokenPaymentCell

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize size = [self.mainBalance.text sizeWithAttributes:@{NSFontAttributeName : self.mainBalance.font}];
    if (size.width > self.mainBalance.bounds.size.width) {
        self.mainBalance.text = self.shortBalance;
    }
}

@end
