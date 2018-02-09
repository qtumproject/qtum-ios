//
//  WalletTypeCellWithCollection.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
#import "PageControl.h"
#import "AnimatedLabelTableViewCell.h"

typedef enum {
	HeaderCellTypeAllVisible,
    HeaderCellTypeAllVisibleWithLastTime,
	HeaderCellTypeWithoutNotCorfirmedBalance,
    HeaderCellTypeWithoutNotCorfirmedBalanceWithLastTime,
	HeaderCellTypeWithoutPageControl,
    HeaderCellTypeWithoutPageControlWithLastTime,
	HeaderCellTypeWithoutAll,
    HeaderCellTypeWithoutAllWithLastTime

} HeaderCellType;

@interface WalletHeaderCell : AnimatedLabelTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *unconfirmedValue;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAddresButton;
@property (weak, nonatomic) IBOutlet PageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *notConfirmedTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *availableTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noInternetConnectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastBalanceUpdateLabel;

@property (weak, nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak, nonatomic) id <Spendable> spendable;

@property (nonatomic, readonly) HeaderCellType type;

- (void)setData:(id <Spendable>) wallet;

- (void)setCellType:(HeaderCellType) type;

- (void)cellYPositionChanged:(CGFloat) yPosition;

- (BOOL)needShowHeader:(CGFloat) yPosition;

- (CGFloat)percentForShowHideHeader:(CGFloat) yPosition;

- (CGFloat)getHeaderHeight;

- (CGFloat)calculateOffsetAfterScroll:(CGFloat) position;

@end
