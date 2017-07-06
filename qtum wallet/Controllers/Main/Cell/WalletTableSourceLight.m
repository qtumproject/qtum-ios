//
//  WalletTableSourceLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTableSourceLight.h"
#import "WalletHeaderCellLight.h"
#import "HistoryTableViewCellLight.h"

@implementation WalletTableSourceLight

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch ([self headerCellType]) {
            case HeaderCellTypeWithoutPageControl:
            case HeaderCellTypeWithoutNotCorfirmedBalance:
            case HeaderCellTypeWithoutAll:
                return 164;
            case HeaderCellTypeAllVisible:
            default:
                return 214;
        }
    } else {
        return 55;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WalletHeaderCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCellLight"];
        
        cell.delegate = self.delegate;
        [cell setCellType:[self headerCellType]];
        [cell setData:self.wallet];
        [self didScrollForheaderCell:tableView];
        
        return cell;
    } else {
        HistoryTableViewCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCellLight"];
        
        HistoryElement *element = self.wallet.historyStorage.historyPrivate[indexPath.row];
        cell.historyElement = element;
        
        return cell;
    }
}

@end
