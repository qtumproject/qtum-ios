//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletHeaderCell.h"
#import "Wallet.h"

@interface WalletHeaderCell ()

@property (nonatomic) HeaderCellType type;

@end

@implementation WalletHeaderCell

- (IBAction)showAddress:(id)sender {
    [self.delegate showAddressInfoWithSpendable:self.spendable];
}

- (void)setData:(Wallet *)wallet{
    self.adressLabel.text = ([wallet isKindOfClass:[Contract class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
    self.adressValueLabel.text = wallet.mainAddress;
    self.valueLabel.text = [NSString stringWithFormat:@"%@",[wallet.balance roundedNumberWithScale:3]];
    self.unconfirmedValue.text = [NSString stringWithFormat:@"%@",[wallet.unconfirmedBalance roundedNumberWithScale:3]];
    self.spendable = wallet;
    
    [self.pageControl setPagesCount:2];
}

- (void)setCellType:(HeaderCellType)type{
    self.type = type;
    switch (self.type) {
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

#pragma mark - Animation

- (void)cellYPositionChanged:(CGFloat)yPosition { }

- (void)changeAlphaByPercent:(CGFloat)percent { }

- (BOOL)needShowHeader:(CGFloat)yPosition { return NO; }

- (CGFloat)percentForShowHideHeader:(CGFloat)yPosition { return 1; };

- (CGFloat)getHeaderHeight{ return 0; }

- (CGFloat)calculateOffsetAfterScroll:(CGFloat)position { return 0.0f; }

@end
