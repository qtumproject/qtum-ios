//
//  ActivityTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ActivityTokenTableViewCell.h"

@interface ActivityTokenTableViewCell ()

@end

@implementation ActivityTokenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor ();
    [self setSelectedBackgroundView:bgColorView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updateTime) name:@"Time" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setHistoryElement:(HistoryElement *) historyElement {
    
    if (historyElement.send) {
        self.typeImageView.image = [UIImage imageNamed:@"history_send"];
        self.typeLabel.text = NSLocalizedString(@"Sent", nil);
    } else {
        self.typeImageView.image = [UIImage imageNamed:@"history_receive"];
        self.typeLabel.text = NSLocalizedString(@"Received", nil);
    }
    
    self.typeImageView.tintColor = customBlueColor ();
    
    _historyElement = historyElement;
    
    self.addressLabel.text = historyElement.address;
    self.amountLabel.text = self.symbolLabel ? [historyElement.amount roundedNumberWithScale:3].stringValue : historyElement.amountString;
    self.dateLabel.text = [self.historyElement formattedDateStringSinceCome];
    
    self.addressLabel.text = historyElement.txHash;
}

- (void)updateTime {
    self.dateLabel.text = [self.historyElement formattedDateStringSinceCome];
}

- (void)changeHighlight:(BOOL) value {
    
    self.typeImageView.tintColor =
    self.typeLabel.textColor =
    self.amountLabel.textColor =
    self.dateLabel.textColor =
    self.addressLabel.textColor = value ? customBlackColor () : customBlueColor ();
    
    self.addressLabel.alpha =
    self.dateLabel.alpha = value ? 1.0f : 0.4f;
}

@end
