//
//  HistoryItemDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemDelegateDataSource.h"
#import "HistoryItemAddressCellTableViewCell.h"


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
    
    NSDictionary *element;
    if (self.mode == From) {
        element = self.item.fromAddreses[indexPath.row];
    } else {
        element = self.item.toAddresses[indexPath.row];
    }
    
    cell.addressLabel.text = [element objectForKey:@"address"];
    cell.valueLabel.text = [NSString stringWithFormat:@"%@", [element objectForKey:@"value"]];
    if (!cell.currencyLabel) {
        cell.valueLabel.text = [NSString stringWithFormat:@"%@", cell.valueLabel.text, NSLocalizedString(@"QTUM", nil)];
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


@end
