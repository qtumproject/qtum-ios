//
//  QTUMImageTagCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMImageTagCell.h"

NSString *const QTUMImageTagCellReuseIdentifire = @"QTUMImageTagCellReuseIdentifire";

@interface QTUMImageTagCell ()


@end

@implementation QTUMImageTagCell

- (void)prepareForReuse {

	[super prepareForReuse];
	self.tagImageView.contentMode = UIViewContentModeCenter;
	self.tagImageView.image = [UIImage imageNamed:@"news-placehodler"];
}


- (CGSize)prefferedSize {

	float cellWidth = [[UIScreen mainScreen] bounds].size.width - 10 - 10;
	float ratio = cellWidth / 355.f;
	float cellHeight = ratio * 192;
	return CGSizeMake (cellWidth, cellHeight);
}


@end
