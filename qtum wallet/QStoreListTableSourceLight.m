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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QStoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QStoreListTableViewCell"];
    
    NSObject *element = [self.array objectAtIndex:indexPath.row];
    
    if ([element isKindOfClass:[QStoreCategory class]]) {
        QStoreCategory *cat = (QStoreCategory *)element;
        cell.nameLabel.text = cat.title;
        cell.amount.text = [NSString stringWithFormat:@"%lu", (unsigned long)cat.elements.count];
        cell.imageIcon.image = [UIImage imageNamed:@"ic-publichedContracts-light"];
    } else {
        QStoreContractElement *el = (QStoreContractElement *)element;
        cell.nameLabel.text = el.name;
        cell.amount.text = [NSString stringWithFormat:@"%@ %@", el.priceString, NSLocalizedString(@"QTUM", nil)];
        cell.imageIcon.image = [UIImage imageNamed:[el getImageNameByType]];
    }
    
    return cell;
}

@end
