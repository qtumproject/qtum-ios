//
//  TokenDetailsTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenDetailsTableSource.h"

static NSInteger const NumberOfSections = 2;
static NSInteger const NumberOfRowsForFirstSection = 4;

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

@interface TokenDetailsTableSource()

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
    UITableViewCell *cell;
    
    switch (row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:BalanceTokenIdentifier];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:QTUMAddressTokenIdentifier];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:NubersTokenIdentifier];
            break;
        case 3:
            cell = [tableView dequeueReusableCellWithIdentifier:AddressesTokenIdentifier];
            break;
    }
    
    return cell;
}

@end
