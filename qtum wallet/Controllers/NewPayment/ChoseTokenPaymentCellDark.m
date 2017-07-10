//
//  ChoseTokenPaymentCellDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChoseTokenPaymentCellDark.h"

@implementation ChoseTokenPaymentCellDark

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.tokenName.textColor = customBlackColor();
        self.balanceSymbol.textColor = customBlackColor();
        self.mainBalanceSymbol.textColor = customBlackColor();
        self.mainBalance.textColor = customBlackColor();
        self.balance.textColor = customBlackColor();
    } else {
        self.tokenName.textColor = customBlueColor();
        self.balanceSymbol.textColor = customBlueColor();
        self.mainBalanceSymbol.textColor = customBlueColor();
        self.mainBalance.textColor = customBlueColor();
        self.balance.textColor = customBlueColor();
    }
}

@end
