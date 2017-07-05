//
//  WalletTypeCellWithCollection.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
#import "CustomPageControl.h"
#import "AnimatedLabelTableViewCell.h"

typedef enum {
    HeaderCellTypeAllVisible,
    HeaderCellTypeWithoutNotCorfirmedBalance,
    HeaderCellTypeWithoutPageControl,
    HeaderCellTypeWithoutAll
} HeaderCellType;

@interface WalletHeaderCell : AnimatedLabelTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *unconfirmedValue;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAddresButton;
@property (weak, nonatomic) IBOutlet CustomPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *notConfirmedTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UILabel *availableTitleLabel;

@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak, nonatomic) id <Spendable> spendable;
@property (nonatomic, readonly) HeaderCellType type;

- (void)setData:(id <Spendable>)wallet;
- (void)setCellType:(HeaderCellType)type;

- (void)cellYPositionChanged:(CGFloat)yPosition;
- (BOOL)needShowHeader:(CGFloat)yPosition;

+ (CGFloat)getHeaderHeight;

@end
