//
//  CopyLabel.m
//  qtum wallet
//
//  Created by Vladimir Sharaev on 27.09.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "CopyLabel.h"

@interface CopyLabel () <PopUpViewControllerDelegate>

@end

@implementation CopyLabel

- (instancetype)init {
	self = [super init];
	if (self) {
		[self addLongGesture];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self addLongGesture];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *) aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self addLongGesture];
	}
	return self;
}

- (void)addLongGesture {
	UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector (longTap)];
	[self addGestureRecognizer:recognizer];
	self.userInteractionEnabled = YES;
}

- (void)longTap {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	NSString *keyString = self.text;
	[pb setString:keyString];

	[[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForAddressCopied] presenter:nil completion:nil];
}

- (void)okButtonPressed:(PopUpViewController *) sender {
	[[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
