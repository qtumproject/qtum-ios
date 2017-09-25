
//
//  QStoreTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreTableSource.h"
#import "QStoreTableViewCell.h"
#import "QStoreCategory.h"

@interface QStoreTableSource() <QStoreCollectionViewSourceDelegate>

@property (nonatomic) NSArray<QStoreCategory *> *categories;

@end

@implementation QStoreTableSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];
    
    QStoreCategory *category = [self.categories objectAtIndex:indexPath.row];
    
    QStoreCollectionViewSource *source = [QStoreCollectionViewSource new];
    source.elements = category.elements;
    [cell setCollectionViewSource:source];
    source.delegate = self;
    
    cell.titleLabel.text = category.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];
    
    if ([cell isKindOfClass:[QStoreTableViewCell class]]) {
        return [[cell class] getHeightCellForRowCount:1];
    }
    
    return [QStoreTableViewCell getHeightCellForRowCount:1];
}

#pragma mark - QStoreCollectionViewSourceDelegate

- (void)didSelectCollectionCellWithElement:(QStoreContractElement *)element {
    if ([self.delegate respondsToSelector:@selector(didSelectCollectionCellWithElement:)]) {
        [self.delegate didSelectCollectionCellWithElement:element];
    }
}

#pragma mark - Methods

- (void)setCategoriesArray:(NSArray<QStoreCategory *> *)categories {
    self.categories = categories;
    [self.tableView reloadData];
}

@end
