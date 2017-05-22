//
//  NewsDataSourceAndDelegate.m
//  qtum wallet
//
//  Created by Никита Федоренко on 20.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NewsDataSourceAndDelegate.h"
#import "NewsCellModel.h"
#import "NewsTableCell.h"
#import "FirstNewTableCell.h"

@interface NewsDataSourceAndDelegate ()

@end

static NSInteger firstCellHeight = 325;
static NSInteger cellHeight = 100;
static NSString* reuseIdentifire = @"NewsTableCell";
static NSString* firstReuseIdentifire = @"FirstNewsTableCell";

@implementation NewsDataSourceAndDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        FirstNewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:firstReuseIdentifire];
        NewsCellModel* object = self.dataArray[indexPath.row];
        [cell setContentWithDict:object];
        return cell;
    } else {
        NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
        NewsCellModel* object = self.dataArray[indexPath.row];
        [cell setContentWithDict:object];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return firstCellHeight;
    }
    return cellHeight;
}

-(void)setDataArray:(NSArray<NewsCellModel *> *)dataArray{
    _dataArray = dataArray;
}

@end
