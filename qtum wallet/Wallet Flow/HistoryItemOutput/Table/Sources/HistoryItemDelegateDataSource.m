//
//  HistoryItemDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemDelegateDataSource.h"
#import "HistoryItemAddressCellTableViewCell.h"
#import "HistoryAddressesHeaderCell.h"


@implementation HistoryItemDelegateDataSource

static CGFloat headerHeight = 24;
#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if (section == 0) {
        return self.item.fromAddresses.count;
	} else {
        return self.item.toAddresses.count;
	}
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	HistoryItemAddressCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HistoryItemAddressCellTableViewCellIdentifier forIndexPath:indexPath];

    NSDictionary *element;
    if (indexPath.section == 0) {
        element = self.item.fromAddresses[indexPath.row];
    } else {
        element = self.item.toAddresses[indexPath.row];
    }

    cell.addressLabel.text = [element objectForKey:@"address"];
    cell.valueLabel.text = [NSString stringWithFormat:@"%@", [element objectForKey:@"value"]];
    if (!cell.currencyLabel) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@ %@", cell.valueLabel.text, self.item.currency];
    } else {
        cell.currencyLabel.text = _item.currency;
    }

	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return headerHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    HistoryAddressesHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:headerReuseIdentifire];
    
    if (section == 0) {
        headerView.headerTextLabel.text = NSLocalizedString(@"From", "");
    } else {
        headerView.headerTextLabel.text = NSLocalizedString(@"To", "");
    }
    
    return headerView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 44;
}


@end
