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

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		WalletHeaderCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCellLight"];

		cell.delegate = self.delegate;
		[cell setCellType:[self headerCellType]];
		[cell setData:self.wallet];
		[self didScrollForheaderCell:tableView];

		return cell;
	} else if ([self isLoadingIndex:indexPath]){

		LoadingFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingFooterCell"];
		return cell;
    } else {
        
        HistoryTableViewCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCellLight"];
        NSIndexPath* path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1 >= 0 ? indexPath.section - 1 : 0];
        
        [self configureCell:cell atIndexPath:path];
        
        return cell;
    }
}

- (void)configureCell:(HistoryTableViewCellLight*)cell atIndexPath:(NSIndexPath*)indexPath {
    
    WalletHistoryEntity *entity = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.historyElement = entity;
    [cell changeHighlight:NO];
}

@end
