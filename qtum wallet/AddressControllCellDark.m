//
//  AddressControllCellDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressControllCellDark.h"

@implementation AddressControllCellDark

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.symbolLabel.textColor =
    self.valueLabel.textColor =
    self.addressLabel.textColor = selected ? customBlackColor() : customBlueColor();
}

@end
