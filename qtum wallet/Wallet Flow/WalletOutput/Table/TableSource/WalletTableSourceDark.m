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

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		WalletHeaderCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCellDark"];

		cell.delegate = self.delegate;
		[cell setCellType:[self headerCellType]];
		[cell setData:self.wallet];
		[self didScrollForheaderCell:tableView];

		self.mainCell = cell;

		return cell;
	} else if ([self isLoadingIndex:indexPath]) {
		LoadingFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingFooterCell"];
		return cell;
    } else {
        
        HistoryTableViewCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCellDark"];
        NSIndexPath* path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1 >= 0 ? indexPath.section - 1 : 0];
        
        [self configureCell:cell atIndexPath:path];
        
        return cell;
    }
}

- (void)configureCell:(HistoryTableViewCellDark*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    WalletHistoryEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.historyElement = entity;
    [cell changeHighlight:NO];
}

@end
