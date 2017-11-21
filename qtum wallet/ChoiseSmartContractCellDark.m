//
//  ChoiseSmartContractCellDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChoiseSmartContractCellDark.h"

@implementation ChoiseSmartContractCellDark

- (void)awakeFromNib {

	[super awakeFromNib];

	self.disclosure.tintColor = customBlueColor ();

	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = customRedColor ();
	[self setSelectedBackgroundView:bgColorView];
}


@end
