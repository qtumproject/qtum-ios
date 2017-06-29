
//
//  QStoreTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreTableSource.h"
#import "QStoreTableViewCell.h"

@interface QStoreTableSource() <QStoreCollectionViewSourceDelegate>

@end

@implementation QStoreTableSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];
    
    QStoreCollectionViewSource *source = [QStoreCollectionViewSource new];
    [cell setCollectionViewSource:source];
    source.delegate = self;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [QStoreTableViewCell getHeightCellForRowCount:2];
    }
    
    return [QStoreTableViewCell getHeightCellForRowCount:1];
}

#pragma mark - QStoreCollectionViewSourceDelegate

- (void)didSelectCollectionCell {
    if ([self.delegate respondsToSelector:@selector(didSelectCollectionCell)]) {
        [self.delegate didSelectCollectionCell];
    }
}

@end
