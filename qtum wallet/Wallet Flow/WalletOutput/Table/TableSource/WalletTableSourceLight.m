//
//  WalletTableSourceLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletTableSourceLight.h"
#import "WalletHeaderCellLight.h"
#import "HistoryTableViewCellLight.h"
#import "LoadingFooterCell.h"

@implementation WalletTableSourceLight

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		switch ([self headerCellType]) {
			case HeaderCellTypeWithoutNotCorfirmedBalance:
			case HeaderCellTypeWithoutAll:
				return 164;
			case HeaderCellTypeWithoutPageControl:
			case HeaderCellTypeAllVisible:
				return 214;
			default:
				return 214;
		}
	} else {
		return 55;
	}
}

@end
