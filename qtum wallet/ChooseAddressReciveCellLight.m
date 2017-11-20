//
//  ChooseAddressReciveCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChooseAddressReciveCellLight.h"

@implementation ChooseAddressReciveCellLight

- (void)awakeFromNib {
	[super awakeFromNib];
	UIView *bgColorView = [[UIView alloc] init];
	bgColorView.backgroundColor = lightBlueColor ();
	[self setSelectedBackgroundView:bgColorView];
}

@end
