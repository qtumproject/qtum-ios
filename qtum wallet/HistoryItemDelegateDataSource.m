//
//  HistoryItemDelegateDataSource.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
    if (self.mode == From) {
        return self.item.fromAddreses.count;
    } else {
        return self.item.toAddresses.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryItemAddressCellTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:HistoryItemAddressCellTableViewCellIdentifier forIndexPath:indexPath];
    if (self.mode == From) {
        cell.addressLabel.text = self.item.fromAddreses[indexPath.row][@"address"];
        cell.valueLabel.text = [NSString stringWithFormat:@"%@ QTUM",self.item.fromAddreses[indexPath.row][@"value"]];
    } else {
        cell.addressLabel.text = self.item.toAddresses[indexPath.row][@"address"];
        cell.valueLabel.text = [NSString stringWithFormat:@"%@ QTUM",self.item.toAddresses[indexPath.row][@"value"]];
    }
//    [cell.valueLabel sizeToFit];
//    [cell setNeedsLayout];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    HistoryItemHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HistoryItemHeaderViewIdentifier];
//    header.headerTextLabel.text = section ? toAddressesHeaderTitle : fromAddressesHeaderTitle;
//    header.backgroundColor = [UIColor whiteColor];
//    return header;
//}


@end
