//
//  BalanceTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BalanceTokenTableViewCell.h"

@interface BalanceTokenTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *balanceTextLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintBalanceText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintBalanceValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraintBalanceText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraintBalanceValue;

@end

@implementation BalanceTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
