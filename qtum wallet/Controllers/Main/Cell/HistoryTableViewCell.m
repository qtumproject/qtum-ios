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
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
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
        
        self.addressLabel.text = [historyElement.toAddresses firstObject][@"address"];
    }else{
        self.typeImage.image = [UIImage imageNamed:@"history_receive"];
        self.typeLabel.text = NSLocalizedString(@"Received", "");
        self.typeLabel.textColor =
        self.typeImage.tintColor = customBlueColor();
        
        self.addressLabel.text = [historyElement.fromAddreses firstObject][@"address"];
    }
}

- (void)changeHighlight:(BOOL)value {
    self.typeImage.tintColor =
    self.typeLabel.textColor =
    self.amountLabel.textColor =
    self.dateLabel.textColor =
    self.addressLabel.textColor = value ? customBlackColor() : customBlueColor();
    
    self.addressLabel.alpha =
    self.dateLabel.alpha = value ? 1.0f : 0.4f;
}

@end
