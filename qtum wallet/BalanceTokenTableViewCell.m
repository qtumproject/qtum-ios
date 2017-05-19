//
//  BalanceTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "BalanceTokenTableViewCell.h"

@interface BalanceTokenTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *notConfirmedBalanceLabel;

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
