//
//  WalletTableSourceDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletTableSourceDark.h"
#import "HistoryTableViewCellDark.h"
#import "WalletHeaderCellDark.h"
#import "LoadingFooterCell.h"

@implementation WalletTableSourceDark

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		switch ([self headerCellType]) {
			case HeaderCellTypeWithoutPageControl:
				return 192;
			case HeaderCellTypeWithoutNotCorfirmedBalance:
				return 161;
			case HeaderCellTypeWithoutAll:
				return 152;
			case HeaderCellTypeAllVisible:
			default:
				return 212;
		}
	} else {
		return 75;
	}
}


@end
