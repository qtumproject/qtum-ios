//
//  TokenDetailsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenDetailsViewController.h"
#import "WalletCoordinator.h"
#import "TokenDetailsTableSource.h"

@interface TokenDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, weak) TokenDetailsTableSource *source;

@end

@implementation TokenDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.source;
    self.tableView.delegate = self.source;
}

- (void)setTableSource:(TokenDetailsTableSource *)source{
    self.source = source;
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

@end
