//
//  QStoreSearchTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreSearchTableSource.h"
#import "QStoreSearchTableViewCell.h"
#import "QStoreContractElement.h"

@interface QStoreSearchTableSource()

@property (nonatomic) NSArray<QStoreContractElement *> *elements;

@end

@implementation QStoreSearchTableSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QStoreSearchTableViewCell"];
    
    QStoreContractElement *element = [self.elements objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = element.name;
    cell.amountLabel.text = element.priceString;
    cell.currencyLabel.text = NSLocalizedString(@"QTUM", nil);
    
    if (indexPath.row == self.elements.count - 1) {
        if ([self.delegate respondsToSelector:@selector(loadMoreElements)]) {
            [self.delegate loadMoreElements];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectSearchCellWithElement:)]) {
        [self.delegate didSelectSearchCellWithElement:[self.elements objectAtIndex:indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    QStoreSearchTableViewCell* cell = (QStoreSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeHighlight:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreSearchTableViewCell* cell = (QStoreSearchTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeHighlight:NO];
}

- (void)setSearchElements:(NSArray<QStoreContractElement *> *)elements {
    self.elements = elements;
}

@end
