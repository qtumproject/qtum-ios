//
//  QStoreListTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreListTableViewCell.h"

@interface QStoreListTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageIcon;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@end

@implementation QStoreListTableViewCell

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
    self.imageIcon.tintColor =
    self.amount.textColor = value ? customBlackColor() : customBlueColor();
}

@end
