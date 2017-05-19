//
//  NubersTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NubersTokenTableViewCell.h"

@interface NubersTokenTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *initialSupplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *decimalUnitsLabel;

@end

@implementation NubersTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
