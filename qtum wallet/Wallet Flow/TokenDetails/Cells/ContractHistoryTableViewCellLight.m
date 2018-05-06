//
//  ContractHistoryTableViewCellLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractHistoryTableViewCellLight.h"

@implementation ContractHistoryTableViewCellLight

- (void)awakeFromNib {
	[super awakeFromNib];

	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = lightBlueColor ();
	[self setSelectedBackgroundView:bgColorView];
}

- (void)setHistoryElement:(HistoryElement *) historyElement {
	[super setHistoryElement:historyElement];

    
    if (!historyElement.confirmed) {
        self.typeImage.image = [UIImage imageNamed:@"ic-confirmation_loader"];
    } else if (historyElement.internal) {
        self.typeImage.image = [UIImage imageNamed:@"ic_sent_to_myself-light"];
    }  else if (historyElement.send) {
        self.typeImage.image = [UIImage imageNamed:@"ic-smartContract-sent-light"];
    } else {
        self.typeImage.image = [UIImage imageNamed:@"ic-received_smartcontract-light"];
    }
}

@end
