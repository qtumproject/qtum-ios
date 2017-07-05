//
//  WalletTableSourceDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTableSourceDark.h"
#import "HistoryTableViewCellDark.h"
#import "WalletHeaderCellDark.h"

@implementation WalletTableSourceDark

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        switch ([self headerCellType]) {
            case HeaderCellTypeWithoutPageControl:
                return 192;
            case HeaderCellTypeWithoutNotCorfirmedBalance:
                return 161;
            case HeaderCellTypeWithoutAll:
                return 152;
            case HeaderCellTypeAllVisible:
            default:
                return 212;
        }
    } else {
        return 75;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WalletHeaderCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"WalletHeaderCellDark"];
        
        cell.delegate = self.delegate;
        [cell setCellType:[self headerCellType]];
        [cell setData:self.wallet];
        [self didScrollForheaderCell:tableView];
        
        return cell;
    } else {
        HistoryTableViewCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCellDark"];
        
        HistoryElement *element = self.wallet.historyStorage.historyPrivate[indexPath.row];
        cell.historyElement = element;
        
        return cell;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [super scrollViewDidScroll:scrollView];
    
    [self didScrollForheaderCell:scrollView];
}

#pragma mark - Private Methods

- (void)didScrollForheaderCell:(UIScrollView *)scrollView{
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    WalletHeaderCellDark *headerCell = [self.tableView cellForRowAtIndexPath:headerIndexPath];
    
    if (!headerCell) {
        return;
    }
    
    if (self.sectionHeaderView) {
        CGFloat headerHeight = [WalletHeaderCell getHeaderHeight];
        CGFloat headerPosition = self.sectionHeaderView.frame.origin.y - scrollView.contentOffset.y;
        if (headerPosition <= headerHeight ) {
            [self.controllerDelegate needShowHeaderForSecondSeciton];
        }else{
            [self.controllerDelegate needHideHeaderForSecondSeciton];
        }
    }
    
    CGFloat position = headerCell.frame.origin.y - scrollView.contentOffset.y;
    [headerCell cellYPositionChanged:position];
    
    if ([headerCell needShowHeader:position]) {
        if ([self.controllerDelegate respondsToSelector:@selector(needShowHeader)]) {
            [self.controllerDelegate needShowHeader];
        }
    }else{
        if ([self.controllerDelegate respondsToSelector:@selector(needHideHeader)]) {
            [self.controllerDelegate needHideHeader];
        }
    }
}

@end
