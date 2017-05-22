//
//  HestoryTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
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
    self.dateLabel.text = historyElement.shortDateString;
    
    if (historyElement.send) {
        self.typeImage.image = [UIImage imageNamed:@"history_send"];
        self.typeLabel.text = NSLocalizedString(@"Sent", "");
        self.typeLabel.textColor =
        self.typeImage.tintColor = customBlueColor();
    }else{
        self.typeImage.image = [UIImage imageNamed:@"history_receive"];
        self.typeLabel.text = NSLocalizedString(@"Received", "");
        self.typeLabel.textColor =
        self.typeImage.tintColor = customBlueColor();
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
