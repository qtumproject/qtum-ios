//
//  HistoryTableViewCellLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryTableViewCellLight.h"

@implementation HistoryTableViewCellLight

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
	} else if (historyElement.send) {
		self.typeImage.image = [UIImage imageNamed:@"ic-sent_light"];
	} else {
		self.typeImage.image = [UIImage imageNamed:@"ic-receive_light"];
	}
}

@end
