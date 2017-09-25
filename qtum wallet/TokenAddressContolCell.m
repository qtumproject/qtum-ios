//
//  TokenAddressContolCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenAddressContolCell.h"
#import "NSNumber+Format.h"

@implementation TokenAddressContolCell

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize size = [self.valueLabel.text sizeWithAttributes:@{NSFontAttributeName : self.valueLabel.font}];
    if (size.width > self.valueLabel.bounds.size.width) {
        self.valueLabel.text = self.shortBalance;
    }
}

@end
