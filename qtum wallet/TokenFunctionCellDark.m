//
//  TokenFunctionCellDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionCellDark.h"

@implementation TokenFunctionCellDark

- (void)awakeFromNib {
	[super awakeFromNib];
	self.disclousere.tintColor = customBlueColor ();

	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = customRedColor ();
	[self setSelectedBackgroundView:bgColorView];
}

- (void)setupWithObject:(AbiinterfaceItem *) object {

	self.functionName.text = object.name;
}


@end
