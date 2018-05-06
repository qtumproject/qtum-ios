//
//  ContractHestoryTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "ContractHistoryTableViewCell.h"

@interface ContractHistoryTableViewCell ()

@end

@implementation ContractHistoryTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updateTime) name:@"Time" object:nil];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setHistoryElement:(id<HistoryElementProtocol>) historyElement {

	_historyElement = historyElement;

    NSLog(@"%@", historyElement.amountString);
    
	self.addressLabel.text = historyElement.address;
	self.amountLabel.text = self.symbolLabel ? [historyElement.amount roundedNumberWithScale:3].stringValue : historyElement.amountString;
	self.dateLabel.text = (historyElement.shortDateString && historyElement.shortDateString.length > 0 && historyElement.confirmed) ? [historyElement formattedDateStringSinceCome] : NSLocalizedString(@"Unconfirmed", nil);

	self.addressLabel.text = historyElement.transactionHash;
}

- (void)updateTime {
    
	self.dateLabel.text = (self.historyElement.shortDateString && self.historyElement.shortDateString.length > 0 && self.historyElement.confirmed) ? [self.historyElement formattedDateStringSinceCome] : NSLocalizedString(@"Unconfirmed", nil);
}

- (void)changeHighlight:(BOOL) value {
}

@end
