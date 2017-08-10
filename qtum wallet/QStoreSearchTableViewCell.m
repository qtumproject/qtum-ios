//
//  QStoreSearchTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreSearchTableViewCell.h"

@interface QStoreSearchTableViewCell()

@end

@implementation QStoreSearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)changeHighlight:(BOOL)value {
    self.nameLabel.textColor =
    self.currencyLabel.textColor =
    self.amountLabel.textColor = value ? customBlackColor() : customBlueColor();
}

@end
