//
//  NewsTableSourceDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsTableSourceDark.h"
#import "NewsCellModel.h"
#import "NewsTableCellDark.h"
#import "FirstNewTableCell.h"

@implementation NewsTableSourceDark

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableCellDark"];
    NewsCellModel* object = self.dataArray[indexPath.row];
    [cell setContentWithDict:object];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setDataArray:(NSArray<NewsCellModel *> *)dataArray{
    _dataArray = dataArray;
}

@end
