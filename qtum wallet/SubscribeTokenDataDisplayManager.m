//
//  SubscribeTokenDataDisplayManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenDataDisplayManager.h"
#import "TockenCellSubscribe.h"

@implementation SubscribeTokenDataDisplayManager

@synthesize delegate, tokensArray;

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tokensArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCellSubscribe* cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
    if (!cell){
        cell = [[TockenCellSubscribe alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tokenCellIdentifire];
    }
    
    Contract* token = self.tokensArray[indexPath.row];
    cell.topSeparator.hidden = NO;
    cell.indicator.hidden = !token.isActive;
    cell.label.text = token.localName;
    [cell setSelectedBackgroundView:[self highlightedView]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectContract:)]) {
        [self.delegate tableView:tableView didSelectContract:self.tokensArray[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TockenCellSubscribe* cell = (TockenCellSubscribe*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = customBlackColor();
    cell.label.textColor = customBlackColor();
    cell.indicator.tintColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TockenCellSubscribe* cell = (TockenCellSubscribe*)[tableView cellForRowAtIndexPath:indexPath];
    cell.topSeparator.backgroundColor = customBlueColor();
    cell.label.textColor = customBlueColor();
    cell.indicator.tintColor = customBlueColor();
}

#pragma mark - Lazy Getter

-(UIView*)highlightedView {
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:customRedColor()];
    return selectedBackgroundView;
}


@end
