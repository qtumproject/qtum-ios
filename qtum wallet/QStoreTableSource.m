
//
//  QStoreTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreTableSource.h"
#import "QStoreTableViewCell.h"

@implementation QStoreTableSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];
    
    [cell setCollectionViewSource:[QStoreCollectionViewSource new]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UITableViewCell *header = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
//    
//    return header;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 33;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [QStoreTableViewCell getHeightCellForRowCount:2];
    }
    
    return [QStoreTableViewCell getHeightCellForRowCount:1];
}

@end
