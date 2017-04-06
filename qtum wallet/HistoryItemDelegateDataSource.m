//
//  HistoryItemDelegateDataSource.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "HistoryItemDelegateDataSource.h"
#import "HistoryElement.h"
#import "HistoryItemHeaderView.h"
#import "HistoryItemAddressCellTableViewCell.h"


static NSString* fromAddressesHeaderTitle = @"From";
static NSString* toAddressesHeaderTitle = @"To";


@implementation HistoryItemDelegateDataSource


#pragma mark - UItableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.item.fromAddreses.count;
    } else {
        return self.item.toAddresses.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryItemAddressCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:HistoryItemAddressCellTableViewCellIdentifier forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.addressLabel.text = self.item.fromAddreses[indexPath.row];
    } else {
        cell.addressLabel.text = self.item.toAddresses[indexPath.row];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HistoryItemHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HistoryItemHeaderViewIdentifier];
    header.headerTextLabel.text = section ? toAddressesHeaderTitle : fromAddressesHeaderTitle;
    header.backgroundColor = [UIColor whiteColor];
    return header;
}


@end
