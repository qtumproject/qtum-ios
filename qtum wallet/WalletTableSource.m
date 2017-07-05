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

@property(nonatomic, weak) HistoryHeaderVIew *sectionHeaderView;
@property (nonatomic, assign) CGFloat lastContentOffset;

@end

static NSInteger countOfSections = 2;

@implementation WalletTableSource

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { return nil; }

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return 0; }

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

@end
