//
//  QStoreSearchTableViewCellDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreSearchTableViewCellDark.h"

@implementation QStoreSearchTableViewCellDark

- (void)awakeFromNib {
	[super awakeFromNib];

	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = customRedColor ();
	[self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL) selected animated:(BOOL) animated {
	[super setSelected:selected animated:animated];

}

- (void)changeHighlight:(BOOL) value {
	self.nameLabel.textColor =
			self.currencyLabel.textColor =
					self.amountLabel.textColor = value ? customBlackColor () : customBlueColor ();
}

@end
