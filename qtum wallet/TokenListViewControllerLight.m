//
//  TokenListViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenListViewControllerLight.h"
#import "TokenCellLight.h"

@interface TokenListViewControllerLight ()

@end

@implementation TokenListViewControllerLight

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TokenCellLight *cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifireLight];
    [cell setupWithObject:self.tokens[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

@end
