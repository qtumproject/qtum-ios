//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletHeaderCell.h"

@implementation WalletHeaderCell

- (IBAction)showAddress:(id)sender {
    [self.delegate showAddressInfoWithSpendable:self.spendable];
}

- (void)setData:(Wallet *)wallet{
    self.adressLabel.text = ([wallet isKindOfClass:[Token class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
    self.adressValueLabel.text = wallet.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%f",wallet.balance];
    self.typeWalletLabel.text = wallet.symbol;
    self.unconfirmedValue.text = [NSString stringWithFormat:@"%f",wallet.unconfirmedBalance];
    self.spendable = wallet;
}

- (void)setCellType:(HeaderCellType)type{
    switch (type) {
        case HeaderCellTypeAllVisible:
            self.pageControl.hidden = NO;
            self.unconfirmedValue.hidden = NO;
            self.notConfirmedTitleLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutPageControl:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = NO;
            self.notConfirmedTitleLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutNotCorfirmedBalance:
            self.pageControl.hidden = NO;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            break;
        case HeaderCellTypeWithoutAll:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            break;
    }
}

@end
