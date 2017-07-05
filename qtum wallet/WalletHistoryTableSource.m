//
//  WalletHistoryDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletHistoryTableSource.h"
#import "HistoryElement.h"
#import "HistoryTableViewCell.h"
#import "WalletHeaderCell.h"
#import "HistoryHeaderVIew.h"

@interface WalletHistoryTableSource ()

@property(weak,nonatomic)HistoryHeaderVIew* sectionHeaderView;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

static NSInteger countOfSections = 2;

@implementation WalletHistoryTableSource

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        WalletHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletTypeCellWithCollectionIdentifire];
        
        cell.delegate = self.delegate;
        [cell setCellType:[self headerCellType]];
        [cell setData:self.wallet];
        [self didScrollForheaderCell:tableView];
        
        return cell;
    } else {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
        if (!cell) {
            cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
        }
        
        HistoryElement *element = self.wallet.historyStorage.historyPrivate[indexPath.row];
        cell.historyElement = element;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return countOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return  self.wallet.historyStorage.historyPrivate.count;
    }
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section != 0) {
        HistoryHeaderVIew *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        self.sectionHeaderView = sectionHeaderView;
        return sectionHeaderView;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 1) {
        return;
    }
    
    HistoryTableViewCell* cell = (HistoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeHighlight:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 1) {
        return;
    }
    
    HistoryTableViewCell* cell = (HistoryTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    [cell changeHighlight:NO];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.lastContentOffset = scrollView.contentOffset.y;
    [self didScrollForheaderCell:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance && offset.y > 0) {
        [self.delegate refreshTableViewData];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        [self.delegate didSelectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        [self.delegate didDeselectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
    }
}

#pragma mark - Private Methods

- (HeaderCellType)headerCellType{
    
    if (self.wallet.unconfirmedBalance == 0.0f && !self.haveTokens) {
        return HeaderCellTypeWithoutAll;
    }
    
    if (self.wallet.unconfirmedBalance == 0.0f) {
        return HeaderCellTypeWithoutNotCorfirmedBalance;
    }
    
    if (!self.haveTokens) {
        return HeaderCellTypeWithoutPageControl;
    }
    
    return HeaderCellTypeAllVisible;
}

- (void)didScrollForheaderCell:(UIScrollView *)scrollView{
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    WalletHeaderCell *headerCell = [self.tableView cellForRowAtIndexPath:headerIndexPath];
    
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
