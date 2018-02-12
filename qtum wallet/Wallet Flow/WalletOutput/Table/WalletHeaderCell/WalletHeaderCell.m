//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletHeaderCell.h"

@interface WalletHeaderCell ()

@property (nonatomic) HeaderCellType type;

@end

@implementation WalletHeaderCell

- (IBAction)showAddress:(id) sender {
	[self.delegate showAddressInfoWithSpendable:self.spendable];
}

- (void)setData:(Wallet *) wallet {
	self.adressLabel.text = ([wallet isKindOfClass:[Contract class]]) ? NSLocalizedString(@"Contract Address", "") : NSLocalizedString(@"QTUM Address", "");
	self.adressValueLabel.text = wallet.mainAddress;
	self.valueLabel.text = [NSString stringWithFormat:@"%@", [[SLocator.walletBalanceFacadeService lastBalance] roundedNumberWithScale:3]];
	self.unconfirmedValue.text = [NSString stringWithFormat:@"%@", [[SLocator.walletBalanceFacadeService lastUnconfirmedBalance] roundedNumberWithScale:3]];
    self.notConfirmedTitleLabel.text = NSLocalizedString(@"Unconfirmed Balance", "");
    self.availableTitleLabel.text = NSLocalizedString(@"Available Balance", "");
    self.noInternetConnectionLabel.text = NSLocalizedString(@"No Internet connection found", @"");
    NSString* lastUpdateTimeString = NSLocalizedString(@"Your balance was last updated at", @"");
    self.lastBalanceUpdateLabel.text = [NSString stringWithFormat:@"%@ %@",lastUpdateTimeString, [SLocator.walletBalanceFacadeService lastUpdateDateSring]];

	self.spendable = wallet;

	[self.pageControl setPagesCount:2];
}

- (void)setCellType:(HeaderCellType) type {
    
	self.type = type;
	switch (self.type) {
		case HeaderCellTypeAllVisible:
			self.pageControl.hidden = NO;
			self.unconfirmedValue.hidden = NO;
			self.notConfirmedTitleLabel.hidden = NO;
            self.noInternetConnectionLabel.hidden = YES;
            self.lastBalanceUpdateLabel.hidden = YES;
			break;
		case HeaderCellTypeWithoutPageControl:
			self.pageControl.hidden = YES;
			self.unconfirmedValue.hidden = NO;
			self.notConfirmedTitleLabel.hidden = NO;
            self.noInternetConnectionLabel.hidden = YES;
            self.lastBalanceUpdateLabel.hidden = YES;
			break;
		case HeaderCellTypeWithoutNotCorfirmedBalance:
			self.pageControl.hidden = NO;
			self.unconfirmedValue.hidden = YES;
			self.notConfirmedTitleLabel.hidden = YES;
            self.noInternetConnectionLabel.hidden = YES;
            self.lastBalanceUpdateLabel.hidden = YES;
			break;
		case HeaderCellTypeWithoutAll:
			self.pageControl.hidden = YES;
			self.unconfirmedValue.hidden = YES;
			self.notConfirmedTitleLabel.hidden = YES;
            self.noInternetConnectionLabel.hidden = YES;
            self.lastBalanceUpdateLabel.hidden = YES;
            break;
        case HeaderCellTypeWithoutAllWithLastTime:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            self.noInternetConnectionLabel.hidden = NO;
            self.lastBalanceUpdateLabel.hidden = NO;
            break;
        case HeaderCellTypeAllVisibleWithLastTime:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            self.noInternetConnectionLabel.hidden = NO;
            self.lastBalanceUpdateLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutNotCorfirmedBalanceWithLastTime:
            self.pageControl.hidden = NO;
            self.unconfirmedValue.hidden = YES;
            self.notConfirmedTitleLabel.hidden = YES;
            self.noInternetConnectionLabel.hidden = NO;
            self.lastBalanceUpdateLabel.hidden = NO;
            break;
        case HeaderCellTypeWithoutPageControlWithLastTime:
            self.pageControl.hidden = YES;
            self.unconfirmedValue.hidden = NO;
            self.notConfirmedTitleLabel.hidden = NO;
            self.noInternetConnectionLabel.hidden = NO;
            self.lastBalanceUpdateLabel.hidden = NO;
			break;
	}
}

#pragma mark - Animation

- (void)cellYPositionChanged:(CGFloat) yPosition {
}

- (void)changeAlphaByPercent:(CGFloat) percent {
}

- (BOOL)needShowHeader:(CGFloat) yPosition {
	return NO;
}

- (CGFloat)percentForShowHideHeader:(CGFloat) yPosition {
	return 1;
};

- (CGFloat)getHeaderHeight {
	return 0;
}

- (CGFloat)calculateOffsetAfterScroll:(CGFloat) position {
	return 0.0f;
}

@end
