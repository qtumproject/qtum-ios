//
//  FavouriteTemplateCollectionViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FavouriteTemplateCollectionViewCell.h"

@implementation FavouriteTemplateCollectionViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL) selected {
	[super setSelected:self];

	self.backgroundColor = selected ? [self selectedBacgroundColor] : [self deselectedBacgroundColor];
}

- (UIColor *)selectedBacgroundColor {
	return customRedColor ();
}

- (UIColor *)deselectedBacgroundColor {
	return customBlueColor ();
}

+ (UIFont *)getLabelFont {
	return [UIFont fontWithName:@"simplonmono-regular" size:9.0f];
}

@end
