//
//  QStoreListTableSourceLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListTableSourceLight.h"
#import "QStoreCategory.h"
#import "QStoreContractElement.h"
#import "QStoreListTableViewCell.h"

@implementation QStoreListTableSourceLight

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	QStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QStoreListTableViewCell"];

	NSObject *element = [self.array objectAtIndex:indexPath.row];

	if ([element isKindOfClass:[QStoreCategory class]]) {
		QStoreCategory *cat = (QStoreCategory *)element;
		cell.nameLabel.text = cat.name;
		cell.amount.text = [cat.fullCountactCount stringValue];
		cell.imageIcon.image = [self getImgeByCategoryType:cat.name isLight:YES];
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

@end
