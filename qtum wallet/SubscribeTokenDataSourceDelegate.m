//
//  SubscribeTokenDataSourceDelegate.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SubscribeTokenDataSourceDelegate.h"
#import "TockenCell.h"

@implementation SubscribeTokenDataSourceDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tokensArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
    if (!cell){
        cell = [[TockenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tokenCellIdentifire];
    }
    if (indexPath.row == 0) {
        cell.topSeparator.hidden = NO;
    }
    id <Spendable> token = self.tokensArray[indexPath.row];
    cell.label.text = token.name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
