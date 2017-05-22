//
//  TokenListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenListViewController.h"
#import "TokenCell.h"

@interface TokenListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TokenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}


#pragma mark - Coordinator invocation

-(void)reloadTable{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didDeselectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TokenCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
    [cell setupWithObject:self.tokens[indexPath.row]];
    return cell;
}

@end
