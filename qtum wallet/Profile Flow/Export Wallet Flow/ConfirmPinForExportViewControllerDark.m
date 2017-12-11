//
//  ConfirmPinForExportViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPinForExportViewControllerDark.h"

@interface ConfirmPinForExportViewControllerDark ()

@end

@implementation ConfirmPinForExportViewControllerDark

- (void)configPasswordView {

	[self.passwordView setStyle:DarkStyle lenght:SLocator.appSettings.isLongPin ? LongType : ShortType];
	self.passwordView.delegate = self;
}

@end
