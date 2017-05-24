//
//  TokenDetailsTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenDetailsTableSource.h"
#import "BalanceTokenTableViewCell.h"
#import "NubersTokenTableViewCell.h"
#import "AddressesTokenTableViewCell.h"
#import "ActivityTokenTableViewCell.h"
#import "QTUMAddressTokenTableViewCell.h"

static NSInteger const NumberOfSections = 2;
static NSInteger const NumberOfRowsForFirstSection = 5;

static CGFloat const ActivityHeaderHeight = 34;
static CGFloat const BalanceTokenHeight = 140;
static CGFloat const QTUMAddressTokenHeight = 47;
static CGFloat const NubersTokenHeight = 51;
static CGFloat const AddressesTokenHeight = 51;
static CGFloat const ActivityTokenHeight = 69;

static NSString *const ActivityHeaderIdentifier = @"ActivityHeaderTokenTableViewCell";
static NSString *const BalanceTokenIdentifier = @"BalanceTokenTableViewCell";
static NSString *const QTUMAddressTokenIdentifier = @"QTUMAddressTokenTableViewCell";
static NSString *const NubersTokenIdentifier = @"NubersTokenTableViewCell";
static NSString *const AddressesTokenIdentifier = @"AddressesTokenTableViewCell";
static NSString *const ActivityTokenIdentifier = @"ActivityTokenTableViewCell";

@interface TokenDetailsTableSource() <QTUMAddressTokenTableViewCellDelegate>

@property (nonatomic, weak) UIView *headerForSecondSection;
@property (nonatomic) CGFloat standartOffsetY;

@end

@implementation TokenDetailsTableSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSections;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getCellForFirstSection:tableView forRow:indexPath.row];
    }else{
        return [tableView dequeueReusableCellWithIdentifier:ActivityTokenIdentifier];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return NumberOfRowsForFirstSection;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat height = 0.0f;
        switch (indexPath.row) {
            case 0:
                return BalanceTokenHeight;
                break;
            case 1:
                return QTUMAddressTokenHeight;
                break;
            case 2:
                return NubersTokenHeight;
                break;
            case 3:
                return AddressesTokenHeight;
                break;
            case 4:
                return AddressesTokenHeight;
                break;
        }
        return height;
    }else{
        return ActivityTokenHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return ActivityHeaderHeight;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:ActivityHeaderIdentifier];
        self.headerForSecondSection = headerCell;
        return  headerCell;
    }
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == 0.0f) {
        self.standartOffsetY = self.headerForSecondSection.frame.origin.y;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat headerY = self.headerForSecondSection.frame.origin.y - scrollView.contentOffset.y;
    
    if (scrollView.contentOffset.y > self.standartOffsetY) {
        headerY = 0.0f;
    }
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidScrollWithSecondSectionHeaderY:)]) {
        [self.delegate scrollViewDidScrollWithSecondSectionHeaderY:headerY];
    }
}

#pragma mark - Private methods

- (UITableViewCell *)getCellForFirstSection:(UITableView *)tableView forRow:(NSInteger)row{
    
    switch (row) {
        case 0:
            return [self configBalanceCellWithTableView:tableView forRow:row];
            break;
        case 1:
            return [self configQTUMAddressTokenCellWithTableView:tableView forRow:row];
            break;
        case 2:
            return [self configNubersTokenCellWithTableView:tableView forRow:row];
            break;
        case 3:
            return [self configSenderAddressesTokenCellWithTableView:tableView forRow:row];
            break;
        case 4:
            return [self configContractAddressesTokenCellWithTableView:tableView forRow:row];
            break;
    }
    
    return [UITableViewCell new];
}

#pragma mark - Configuration Cells

-(UITableViewCell *)configBalanceCellWithTableView:(UITableView *)tableView forRow:(NSInteger)row {
    BalanceTokenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:BalanceTokenIdentifier];
    cell.availableBalanceLabel.text = [NSString stringWithFormat:@"%f",self.token.balance];
    cell.notConfirmedBalanceLabel.text = [NSString stringWithFormat:@"%d",0];
    return cell;
}

-(UITableViewCell *)configQTUMAddressTokenCellWithTableView:(UITableView *)tableView forRow:(NSInteger)row {
    QTUMAddressTokenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:QTUMAddressTokenIdentifier];
    cell.delegate = self;
    cell.addressLabel.text = self.token.mainAddress;
    return cell;
}

-(UITableViewCell *)configNubersTokenCellWithTableView:(UITableView *)tableView forRow:(NSInteger)row {
    NubersTokenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:NubersTokenIdentifier];
    cell.initialSupplyLabel.text = [NSString stringWithFormat:@"%@",self.token.totalSupply];
    cell.decimalUnitsLabel.text = [NSString stringWithFormat:@"%@",self.token.decimals];
    return cell;
}

-(UITableViewCell *)configSenderAddressesTokenCellWithTableView:(UITableView *)tableView forRow:(NSInteger)row {
    AddressesTokenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AddressesTokenIdentifier];
    cell.addressNameLabel.text = NSLocalizedString(@"Sender Address", @"");
    cell.addressLabel.text = self.token.adresses.firstObject;
    return cell;
}

-(UITableViewCell *)configContractAddressesTokenCellWithTableView:(UITableView *)tableView forRow:(NSInteger)row {
    AddressesTokenTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:AddressesTokenIdentifier];
    cell.addressNameLabel.text = NSLocalizedString(@"Contract Address", @"");
    cell.addressLabel.text = self.token.mainAddress;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - QTUMAddressTokenTableViewCellDelegate

- (void)actionPlus:(id)sender{
    [self.delegate didPressedInfoActionWithToken:self.token];
}


@end
