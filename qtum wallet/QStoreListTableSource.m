//
//  QStoreListTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListTableSource.h"
#import "QStoreListTableViewCell.h"

#import "QStoreCategory.h"
#import "QStoreContractElement.h"

@implementation QStoreListTableSource

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	QStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QStoreListTableViewCell"];

	NSObject *element = [self.array objectAtIndex:indexPath.row];

	if ([element isKindOfClass:[QStoreCategory class]]) {
		QStoreCategory *cat = (QStoreCategory *)element;
		cell.nameLabel.text = cat.name;
		cell.amount.text = [cat.fullCountactCount stringValue];
		cell.imageIcon.image = [self getImgeByCategoryType:cat.name isLight:NO];
	} else {
		QStoreContractElement *el = (QStoreContractElement *)element;
		cell.nameLabel.text = el.name;
		cell.amount.text = [NSString stringWithFormat:@"%@ %@", el.priceString, NSLocalizedString(@"QTUM", nil)];
		cell.imageIcon.image = [UIImage imageNamed:[el getImageNameByType]];
	}

	if (indexPath.row == self.array.count - 1) {
		if ([self.delegate respondsToSelector:@selector (loadMoreElements)]) {
			[self.delegate loadMoreElements];
		}
	}

	return cell;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return self.array.count;
}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 60;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	if ([self.delegate respondsToSelector:@selector (didSelectCell:)]) {
		[self.delegate didSelectCell:indexPath];
	}
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {
	QStoreListTableViewCell *cell = (QStoreListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell changeHighlight:YES];
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {
	QStoreListTableViewCell *cell = (QStoreListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell changeHighlight:NO];
}

- (UIImage *)getImgeByCategoryType:(NSString *) type isLight:(BOOL) isLight {
	NSString *imageName = [NSString stringWithFormat:@"%@%@", type, isLight ? @"-light" : @""];
	return [UIImage imageNamed:imageName];
}

@end
