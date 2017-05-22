//
//  TokenFunctionViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenFunctionViewController.h"
#import "TokenFunctionCell.h"

@interface TokenFunctionViewController ()

@end

@implementation TokenFunctionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectFunctionIndexPath:indexPath withItem:self.formModel.functionItems[indexPath.row] andToken:self.token];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didDeselectFunctionIndexPath:indexPath withItem:self.formModel.functionItems[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.formModel.functionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TokenFunctionCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenFunctionCellIdentifire];
    [cell setupWithObject:self.formModel.functionItems[indexPath.row]];
    return cell;
}

@end
