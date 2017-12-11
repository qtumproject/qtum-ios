//
//  TokenDetailInfoLightCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailInfoLightCell.h"
#import "GradientView.h"

@interface TokenDetailInfoLightCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *addressesInfoWidget;
@property (weak, nonatomic) IBOutlet UIView *balanceWidget;

@end

@implementation TokenDetailInfoLightCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL) selected animated:(BOOL) animated {
	[super setSelected:selected animated:animated];
}

- (void)layoutSubviews {

	[super layoutSubviews];

	CGSize size = [self.availableBalance.text sizeWithAttributes:@{NSFontAttributeName: self.availableBalance.font}];
	if (size.width > self.availableBalance.bounds.size.width) {
		self.availableBalance.text = self.shortBalance;
	} else {
		self.availableBalance.text = self.longBalance;
	}

	size = [self.longTotalSupply sizeWithAttributes:@{NSFontAttributeName: self.initialSupply.font}];
	if (size.width > self.initialSupply.bounds.size.width) {
		self.initialSupply.text = self.shortTotalSupply;
	} else {
		self.initialSupply.text = self.longTotalSupply;
	}
}

- (void)updateWithScrollView:(UIScrollView *) scrollView {

	CGFloat offset = scrollView.contentOffset.y;
	CGFloat widgetHeight = self.addressesInfoWidget.frame.size.height;
	CGFloat navBarHeight = 64;

	//MOVE ONLY WIDGET
	if (offset > 0 && offset < widgetHeight) {

		self.topConstraint.constant = offset - navBarHeight;
	}

		//CEIL OFFET AND CONSTRAINS VALUE
	else if (offset <= 0) {

		self.topConstraint.constant = -navBarHeight;
	} else if (offset >= widgetHeight - navBarHeight) {

		self.topConstraint.constant = widgetHeight - navBarHeight;
	}

	[self cellYPositionChanged:offset];
}


- (void)cellYPositionChanged:(CGFloat) yPosition {

	CGFloat startFadingPoint = yPosition - 40;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET

	if (self.contentView.subviews.count > 1) {

		for (UIView *view in self.contentView.subviews[1].subviews) {

			CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
			CGFloat emptyAlphaFirstPoiny;//DETERMINE POINT WHEN OFFSET SHOUD BE 0

			if ([view isKindOfClass:[GradientView class]]) {

				fullAlphaLastPoin = view.frame.size.height * 0.65f;
				emptyAlphaFirstPoiny = view.frame.origin.y + view.frame.size.height;
			} else {

				fullAlphaLastPoin = view.frame.origin.y;
				emptyAlphaFirstPoiny = view.frame.origin.y + view.frame.size.height;
			}

			view.alpha = (fullAlphaLastPoin - startFadingPoint) / (emptyAlphaFirstPoiny - fullAlphaLastPoin);
		}
	}
}

@end
