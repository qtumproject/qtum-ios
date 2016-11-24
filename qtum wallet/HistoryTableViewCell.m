//
//  HestoryTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHistoryElement:(HistoryElement *)historyElement
{
    _historyElement = historyElement;
    
    self.addressLabel.text = historyElement.address;
    self.amountLabel.text = historyElement.amountString;
    self.dateLabel.text = historyElement.dateString;
    
    if (historyElement.send) {
        self.amountLabel.textColor = historyRedColor();
        self.typeImage.image = [UIImage imageNamed:@"send"];
        self.typeLabel.text = @"Sent";
    }else{
        self.amountLabel.textColor = historyGreenColor();
        self.typeImage.image = [UIImage imageNamed:@"received"];
        self.typeLabel.text = @"Received";
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
