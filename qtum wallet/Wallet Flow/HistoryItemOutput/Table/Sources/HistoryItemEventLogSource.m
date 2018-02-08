//
//  HistoryItemEventLogSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryItemEventLogSource.h"
#import "TransactionReceipt+Extension.h"
#import "Log+CoreDataProperties.h"
#import "HistoryEventLogAddressCell.h"
#import "RecieptLogDTO.h"

typedef NS_ENUM(NSUInteger, EventLogsCellsType) {
    Addresses,
    Topics,
    Data
};

@interface HistoryItemEventLogSource () <HistoryEventLogsConvertableDataCellDelegate>

@end


@implementation HistoryItemEventLogSource

#pragma mark Setters

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    
    RecieptLogDTO* dto = self.logs[section];
    return dto.data.count + dto.topics.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    RecieptLogDTO* dto = self.logs[indexPath.section];
    NSInteger topicsCount = dto.topics.count;
    EventLogsCellsType type;
    
    if (indexPath.row == 0) {
        type = Addresses;
    } else if (indexPath.row <topicsCount + 1){
        type = Topics;
    } else {
        type = Data;
    }
    
    if (type == Addresses) {
        return [self configAddressWith:dto.contractAddress withTableView:tableView];
    } else if (type == Topics) {

        return [self configTopicWith:dto.topics[indexPath.row - 1] withTableView:tableView index:indexPath];
    } else {

        return [self configDataWith:dto.data[indexPath.row - 1 - dto.topics.count] withTableView:tableView index:indexPath];
    }
}

- (UITableViewCell*)configTopicWith:(ValueRepresentationEntity*) data withTableView:(UITableView*) tableView index:(NSIndexPath*) indexPath  {

    HistoryEventLogsConvertableDataCell* cell = [tableView dequeueReusableCellWithIdentifier:historyEventLogsConvertableDataCellIdentifier];
    cell.titleTextLabel.text = NSLocalizedString(@"Topics", @"");
    cell.valuesModel = data;
    
    NSInteger index = indexPath.row;
    RecieptLogDTO* dto = self.logs[indexPath.section];
    NSInteger topicsCount = dto.topics.count;

    if (index == 1) {
        cell.isFirst = YES;
    }
    if (index == topicsCount){
        cell.isLast = YES;
    }
    
    cell.isMiddle = cell.isFirst != YES && cell.isLast != YES;
    cell.delegate = self;

    return cell;
}

- (UITableViewCell*)configAddressWith:(NSString*) address withTableView:(UITableView*) tableView {
    
    HistoryEventLogAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:historyEventLogAddressCellIdentifier];
    cell.titleTextLabel.text = NSLocalizedString(@"Address", @"");
    cell.valueTextLabel.text = address;
    [cell sizeToFitLabels];
    return cell;
}

- (UITableViewCell*)configDataWith:(ValueRepresentationEntity*) data withTableView:(UITableView*) tableView index:(NSIndexPath*) indexPath {
    
    HistoryEventLogsConvertableDataCell* cell = [tableView dequeueReusableCellWithIdentifier:historyEventLogsConvertableDataCellIdentifier];
    cell.titleTextLabel.text = NSLocalizedString(@"Data", @"");
    cell.valuesModel = data;
    
    NSInteger index = indexPath.row;
    RecieptLogDTO* dto = self.logs[indexPath.section];
    NSInteger topicsCount = dto.topics.count;
    NSInteger dataCount = dto.data.count;

    if (index == topicsCount + 1) {
        cell.isFirst = YES;
    }
    
    if (index == topicsCount + dataCount){
        cell.isLast = YES;
    }
    
    cell.isMiddle = cell.isFirst != YES && cell.isLast != YES;
    cell.delegate = self;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    return self.logs.count;
}

#pragma mark - HistoryEventLogsConvertableDataCellDelegate

- (void)convertValue:(NSString*) value frame:(CGRect)position withHandler:(ConversionResultHendler) handler {

    [self.delegate convertValue:value frame:position withHandler:handler];
}

- (void)tableViewCellChanged {
    
    [UIView animateWithDuration:0.1 animations:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

@end
