//
//  HistoryItemOverviewSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryItemOverviewSource.h"
#import "TransactionReceipt+Extension.h"
#import "HistoryOverviewTableCell.h"

@interface HistoryItemOverviewSource () <HistoryOverviewTableCellDelegate>

@end

typedef NS_ENUM(NSUInteger, OverviewCellsType) {
    TxHash,
    BlockHash,
    BlockNumber,
    ContractAddress,
    GasUsed,
    CumulativeGasUsed
};

@implementation HistoryItemOverviewSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    
    if (self.reciept.contractAddress) {
        return 6;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    HistoryOverviewTableCell* cell = [tableView dequeueReusableCellWithIdentifier:historyOverviewTableCellIdentifier];
    
    NSString* title = @"";
    NSString* value = @"";
    BOOL needHideButton = NO;

    
    switch (indexPath.row) {
        case TxHash:
            
            title = NSLocalizedString(@"TxHash", @"");
            value = self.item.transactionHash;
            break;
        case BlockHash:
            
            title = NSLocalizedString(@"BlockHash", @"");
            value = self.item.blockHash;
            break;
        case BlockNumber:
            
            title = NSLocalizedString(@"BlockNumber", @"");
            value = [NSString stringWithFormat:@"%li",(long)self.item.blockNumber];
            break;
            
        case ContractAddress:
            
            title = NSLocalizedString(@"ContractAddress", @"");
            value = self.reciept.contractAddress;
            break;
        case GasUsed:
            
            title = NSLocalizedString(@"GasUsed", @"");
            value = [NSString stringWithFormat:@"%lli",self.reciept.gasUsed];
            needHideButton = YES;
            break;
        case CumulativeGasUsed:
            
            title = NSLocalizedString(@"Cumulative Gas Used", @"");
            value = [NSString stringWithFormat:@"%lli",self.reciept.cumulativeGasUsed];
            needHideButton = YES;
            
            break;
            
        default:
            break;
    }
    
    cell.valueTextLabel.text = value;
    cell.titleTextLabel.text = title;
    cell.delegate = self;
    cell.button.hidden = needHideButton;
    [cell sizeToFitLabels];
    
    return cell;
}

#pragma mark - HistoryOverviewTableCellDelegate

- (void)didPressedCopyWithValue:(NSString*) value {
    
    [self.delegate didPressedCopyWithValue:value];
}

@end
