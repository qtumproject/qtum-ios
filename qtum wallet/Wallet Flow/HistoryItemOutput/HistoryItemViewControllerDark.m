//
//  HistoryItemViewControllerDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemViewControllerDark.h"

CGFloat confirmedConstant = 150.0f;
CGFloat notConfirmedConstant = 180.0f;

@interface HistoryItemViewControllerDark ()

@property (weak, nonatomic) IBOutlet UIView *notConfirmedDesk;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBoardHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *timeTextLabel;

@end

@implementation HistoryItemViewControllerDark

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)configWithItem {

	[super configWithItem];

	self.notConfirmedDesk.hidden = self.item.confirmed;
	self.topBoardHeightConstraint.constant = self.item.confirmed ? confirmedConstant : notConfirmedConstant;
	self.timeTextLabel.text = self.item.send ? NSLocalizedString(@"Sent Time", nil) : NSLocalizedString(@"Received Time", nil);
}

@end
