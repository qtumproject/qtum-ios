//
//  ContractHistoryTableViewCellDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractHistoryTableViewCellDark.h"

@implementation ContractHistoryTableViewCellDark

- (void)awakeFromNib {
	[super awakeFromNib];

	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = customRedColor ();
	[self setSelectedBackgroundView:bgColorView];
}

- (void)setHistoryElement:(HistoryElement *) historyElement {
	[super setHistoryElement:historyElement];

    
    
    if (historyElement.internal) {
        self.typeImage.image = [UIImage imageNamed:@"ic-sent_to_myself"];
        self.typeLabel.text = NSLocalizedString(@"Internal\ntransaction", nil);
    }  else if (historyElement.send) {
        self.typeImage.image = [UIImage imageNamed:@"ic-sent_smartContract"];
        self.typeLabel.text = NSLocalizedString(@"Sent\ncontract", nil);
    } else {
        self.typeImage.image = [UIImage imageNamed:@"ic-received_smartcontract-dark"];
        self.typeLabel.text = NSLocalizedString(@"Receive\ncontract", nil);
    }

	self.typeImage.tintColor = customBlueColor ();
}

- (void)changeHighlight:(BOOL) value {
	self.typeImage.tintColor =
			self.typeLabel.textColor =
					self.amountLabel.textColor =
							self.dateLabel.textColor =
									self.addressLabel.textColor = value ? customBlackColor () : customBlueColor ();

	self.addressLabel.alpha =
			self.dateLabel.alpha = value ? 1.0f : 0.4f;
}

@end
