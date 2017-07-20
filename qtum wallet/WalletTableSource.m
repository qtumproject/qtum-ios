//
//  WalletHistoryDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTableSource.h"
#import "HistoryElement.h"
#import "HistoryTableViewCell.h"

@interface WalletTableSource ()

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, weak) HistoryHeaderVIew *sectionHeaderView;

@end

static NSInteger countOfSections = 2;

@implementation WalletTableSource

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { return nil; }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 0; }

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
    DLog(@"scrollViewDidEndDecelerating");
    
    if (!self.mainCell) return;
    CGFloat diff = [self.mainCell calculateOffsetAfterScroll:scrollView.contentOffset.y];
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - diff) animated:YES];
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
    
    if (decelerate) {
        return;
    }
    
    if (!self.mainCell) return;
    CGFloat diff = [self.mainCell calculateOffsetAfterScroll:aScrollView.contentOffset.y];
    [aScrollView setContentOffset:CGPointMake(aScrollView.contentOffset.x, aScrollView.contentOffset.y - diff) animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section) {
        [self.delegate didSelectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
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

#pragma mark - Public Methods

- (void)didScrollForheaderCell:(UIScrollView *)scrollView{
    NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    WalletHeaderCell *headerCell = [self.tableView cellForRowAtIndexPath:headerIndexPath];
    
    if (!headerCell) {
        return;
    }
    
    if (self.sectionHeaderView) {
        CGFloat headerHeight = [headerCell getHeaderHeight];
        CGFloat headerPosition = self.sectionHeaderView.frame.origin.y - scrollView.contentOffset.y;
        if (headerPosition <= headerHeight ) {
            if ([self.controllerDelegate respondsToSelector:@selector(needShowHeaderForSecondSeciton)]) {
                [self.controllerDelegate needShowHeaderForSecondSeciton];
            }
        }else{
            if ([self.controllerDelegate respondsToSelector:@selector(needHideHeaderForSecondSeciton)]) {
                [self.controllerDelegate needHideHeaderForSecondSeciton];
            }
        }
    }
    
    CGFloat position = headerCell.frame.origin.y - scrollView.contentOffset.y;
    [headerCell cellYPositionChanged:position];
    
    if ([headerCell needShowHeader:position]) {
        if ([self.controllerDelegate respondsToSelector:@selector(needShowHeader:)]) {
            [self.controllerDelegate needShowHeader:[headerCell percentForShowHideHeader:position]];
        }
    }else{
        if ([self.controllerDelegate respondsToSelector:@selector(needHideHeader:)]) {
            [self.controllerDelegate needHideHeader:[headerCell percentForShowHideHeader:position]];
        }
    }
}

@end
