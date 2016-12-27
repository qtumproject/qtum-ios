//
//  HistoryViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"
#import "BlockchainInfoManager.h"
#import "HistoryElement.h"

@interface HistoryViewController ()

@property (nonatomic,assign) BOOL historyLoaded;
@property (nonatomic, strong) NSArray *historyArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self actionRefreshButton:nil];
}

#pragma mark - Actions

- (IBAction)actionRefreshButton:(id)sender
{
    [SVProgressHUD show];
    [self getHistory];
}

#pragma mark - Private Methods

- (void)getHistory
{
    self.historyLoaded = NO;
    
    __weak typeof(self) weakSelf = self;
    [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
        weakSelf.historyLoaded = YES;
        weakSelf.historyArray = responseObject;
        [weakSelf.tableView reloadData];
        
        if (weakSelf.historyLoaded) {
            [SVProgressHUD dismiss];
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        weakSelf.historyLoaded = YES;
        if ( weakSelf.historyLoaded) {
            [SVProgressHUD showErrorWithStatus:@"Some error"];
        }
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
    }
    
    HistoryElement *element = self.historyArray[indexPath.row];
    cell.historyElement = element;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.historyArray.count;
}


@end
