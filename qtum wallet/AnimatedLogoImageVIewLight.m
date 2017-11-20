//
//  AnimatedLogoImageVIewLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AnimatedLogoImageVIewLight.h"

@implementation AnimatedLogoImageVIewLight

- (instancetype)initWithCoder:(NSCoder *) aDecoder {

	self = [super initWithCoder:aDecoder];
	if (self) {
		self.needRepeate = NO;
		self.animationTime = 1;
	}
	return self;
}

- (void)layoutSubviews {

	if (self.secondImageView == nil) {
		self.secondImageView = [[UIImageView alloc] initWithImage:self.image];
		self.secondImageView.contentMode = UIViewContentModeBottom;
		self.secondImageView.clipsToBounds = YES;
		self.secondImageView.hidden = YES;
		self.secondImageView.translatesAutoresizingMaskIntoConstraints = NO;
		[self.secondImageView setTintColor:[UIColor whiteColor]];
		[self addSubview:self.secondImageView];

		[self setNeedsUpdateConstraints];
	}

	[super layoutSubviews];
}

- (void)addConstraintsToSecondImage {

	if (self.secondImageView == nil)
		return;
	if (self.topConstraintForSecondImageView != nil)
		return;

	NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
																	 attribute:NSLayoutAttributeTop
																	 relatedBy:NSLayoutRelationEqual
																		toItem:self
																	 attribute:NSLayoutAttributeTop
																	multiplier:1.0f
																	  constant:self.frame.size.height];

	NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
																		attribute:NSLayoutAttributeBottom
																		relatedBy:NSLayoutRelationEqual
																		   toItem:self
																		attribute:NSLayoutAttributeBottom
																	   multiplier:1.0f
																		 constant:0.0f];

	NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
																		 attribute:NSLayoutAttributeLeading
																		 relatedBy:NSLayoutRelationEqual
																			toItem:self
																		 attribute:NSLayoutAttributeLeading
																		multiplier:1.0f
																		  constant:0.0f];

	NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.secondImageView
																		  attribute:NSLayoutAttributeTrailing
																		  relatedBy:NSLayoutRelationEqual
																			 toItem:self
																		  attribute:NSLayoutAttributeTrailing
																		 multiplier:1.0f
																		   constant:0.0f];

	[self addConstraints:@[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint]];

	self.topConstraintForSecondImageView = topConstraint;
}

@end
