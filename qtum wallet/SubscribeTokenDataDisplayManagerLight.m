//
//  SubscribeTokenDataDisplayManagerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenDataDisplayManagerLight.h"
#import "TockenCellSubscribe.h"


@implementation SubscribeTokenDataDisplayManagerLight

#pragma mark - UITableViewDataSource

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCellSubscribe* cell = (TockenCellSubscribe*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = lightBlueColor();

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TockenCellSubscribe* cell = (TockenCellSubscribe*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Lazy Getter

-(UIView*)highlightedView {
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:lightBlueColor()];
    return selectedBackgroundView;
}


@end
