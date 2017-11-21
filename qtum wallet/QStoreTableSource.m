
//
//  QStoreTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreTableSource.h"
#import "QStoreTableViewCell.h"
#import "QStoreMainScreenCategory.h"

@interface QStoreTableSource () <QStoreCollectionViewSourceDelegate>

@property (nonatomic) NSArray<QStoreMainScreenCategory *> *categories;

@end

@implementation QStoreTableSource

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];

	QStoreMainScreenCategory *category;
	for (NSInteger i = indexPath.row; i < self.categories.count; i++) {
		category = [self.categories objectAtIndex:i];
		if (category.elements.count > 0) {
			break;
		}
	}

	QStoreCollectionViewSource *source = [QStoreCollectionViewSource new];
	source.elements = category.elements;
	[cell setCollectionViewSource:source];
	source.delegate = self;

	cell.titleLabel.text = category.name;

	return cell;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	NSInteger categoriesCount = self.categories.count;
	for (QStoreMainScreenCategory *cat in self.categories) {
		if (cat.elements.count == 0) {
			categoriesCount--;
		}
	}
	return categoriesCount;
}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	QStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[QStoreTableViewCell getIdentifier]];

	if ([cell isKindOfClass:[QStoreTableViewCell class]]) {
		return [[cell class] getHeightCellForRowCount:1];
	}

	return [QStoreTableViewCell getHeightCellForRowCount:1];
}

#pragma mark - QStoreCollectionViewSourceDelegate

- (void)didSelectCollectionCellWithElement:(QStoreContractElement *) element {
	if ([self.delegate respondsToSelector:@selector (didSelectCollectionCellWithElement:)]) {
		[self.delegate didSelectCollectionCellWithElement:element];
	}
}

#pragma mark - Methods

- (void)setCategoriesArray:(NSArray<QStoreMainScreenCategory *> *) categories {
	self.categories = categories;
	[self.tableView reloadData];
}

@end
