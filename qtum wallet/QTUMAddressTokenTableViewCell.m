//
//  QTUMAddressTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "QTUMAddressTokenTableViewCell.h"

@interface QTUMAddressTokenTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation QTUMAddressTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionPlus:(id)sender {
}

@end
