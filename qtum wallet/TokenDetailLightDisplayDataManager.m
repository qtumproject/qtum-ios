//
//  TokenDetailLightDisplayDataManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailLightDisplayDataManager.h"
#import "HistoryHeaderVIew.h"
#import "TokenDetailInfoLightCell.h"
#import "ApplicationCoordinator.h"
#import "Wallet.h"

@interface TokenDetailLightDisplayDataManager ()

@property (weak, nonatomic) TokenDetailInfoLightCell* infoHeaderCell;

@end

static NSInteger fullInformationHeight = 211;
static NSInteger standartHistoryCellHeight = 50;


@implementation TokenDetailLightDisplayDataManager

@synthesize token, delegate;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        TokenDetailInfoLightCell * cell = [tableView dequeueReusableCellWithIdentifier:tokenDetailInfoLightCellIdentifire];
        self.infoHeaderCell = (TokenDetailInfoLightCell*)cell;
        cell.decimalUnits.text = [NSString stringWithFormat:@"%@",token.decimals ?: @""];
        cell.initialSupply.text = token.totalSupplyString;
        cell.tokenAddress.text = SLocator.walletManager.wallet.mainAddress;
        cell.availableBalance.text = token.balanceString;
        cell.senderAddress.text = token.contractAddress;
        cell.symbol.text = token.symbol;
        cell.shortBalance = token.shortBalanceString;
        cell.shortTotalSupply = token.shortTotalSupplyString;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCellLight"];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }else{
        return token.historyArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return fullInformationHeight;
    } else {
        return standartHistoryCellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else {
        return 25;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        UIView *headerCell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
        return  headerCell;
    }
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *) scrollView {
    
    [self.infoHeaderCell updateWithScrollView:scrollView];
    
    if ([self.delegate respondsToSelector:@selector(updateWithYOffset:)]) {
        [self.delegate updateWithYOffset:scrollView.contentOffset.y];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - QTUMAddressTokenTableViewCellDelegate

- (void)actionPlus:(id)sender{
    [self.delegate didPressedInfoActionWithToken:self.token];
}

@end
