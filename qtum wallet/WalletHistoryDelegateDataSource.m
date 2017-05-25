//
//  WalletHistoryDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletHistoryDelegateDataSource.h"
#import "HistoryElement.h"
#import "HistoryTableViewCell.h"
#import "WalletHeaderCell.h"
#import "HistoryHeaderVIew.h"

@interface WalletHistoryDelegateDataSource ()

@property(weak,nonatomic)HistoryHeaderVIew* sectionHeaderView;

@end

static NSInteger countOfSections = 2;

@implementation WalletHistoryDelegateDataSource

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WalletHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:WalletTypeCellWithCollectionIdentifire];
        
        cell.delegate = self.delegate;
        [cell setData:self.wallet];
        [cell setCellType:[self getHeaderCellType]];
        
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
        switch ([self getHeaderCellType]) {
            case HeaderCellTypeWithoutPageControl:
                return 192;
            case HeaderCellTypeWithoutNotCorfirmedBalance:
                return 161;
            case HeaderCellTypeWithoutAll:
                return 152;
            case HeaderCellTypeAllVisible:
            default:
                return 152;
        }
    } else {
        return 75;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return ceilf(32.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section != 0) {
        HistoryHeaderVIew *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        sectionHeaderView.balanceLabel.text = [NSString stringWithFormat:@"%0.6f",self.wallet.balance];
        self.sectionHeaderView = sectionHeaderView;
        return sectionHeaderView;
    }else {
        return nil;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat previousOffset;
    static CGFloat fixedHeaderPosition = 148;
    CGFloat scrollDiff = scrollView.contentOffset.y - previousOffset;
    BOOL isScrollingUp = scrollDiff > fixedHeaderPosition;

    if (isScrollingUp) {
        [self.controllerDelegate fadeInNavigationBar];
        [self.sectionHeaderView fadeOutActivity];
    } else {
        [self.controllerDelegate fadeOutNavigationBar];
        [self.sectionHeaderView fadeInActivity];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didDeselectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
}

#pragma mark - Private Methods

- (HeaderCellType)getHeaderCellType{
    
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
