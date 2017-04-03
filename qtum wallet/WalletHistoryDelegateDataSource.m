//
//  WalletHistoryDelegateDataSource.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletHistoryDelegateDataSource.h"
#import "HistoryElement.h"
#import "HistoryTableViewCell.h"
#import "WalletTypeCollectionDataSourceDelegate.h"
#import "WalletTypeCellWithCollection.h"
#import "HistoryHeaderVIew.h"
#import "WalletModel.h"

@interface WalletHistoryDelegateDataSource ()


@end

static NSInteger countOfSections = 2;

@implementation WalletHistoryDelegateDataSource

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WalletTypeCellWithCollection *cell = [tableView dequeueReusableCellWithIdentifier:WalletTypeCellWithCollectionIdentifire];
        cell.collectionView.delegate = self.collectionDelegateDataSource;
        cell.collectionView.dataSource = self.collectionDelegateDataSource;
        [cell.collectionView reloadData];
        return cell;
    } else {
        HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
        if (!cell) {
            cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
        }
        
        HistoryElement *element = self.wallet.historyArray[indexPath.row];
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
        return  self.wallet.historyArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 212;
    } else {
        return 75;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 32.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        HistoryHeaderVIew *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        return sectionHeaderView;
    }else {
        return nil;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = 50;
    if(y > h + reload_distance) {
        [self.delegate setLastPageForHistory:0 needIncrease:YES];
        [self.delegate refreshTableViewDataLocal:NO];
    }
}

@end
