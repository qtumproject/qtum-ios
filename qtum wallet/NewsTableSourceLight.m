//
//  NewsTableSourceLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NewsTableSourceLight.h"
#import "NewsCellModel.h"
#import "NewsTableCellLight.h"

@implementation NewsTableSourceLight

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableCellLight"];
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
