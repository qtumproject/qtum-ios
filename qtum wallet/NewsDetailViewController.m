//
//  NewsDetailViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDetailViewController.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsDetailViewController

@synthesize delegate, newsItem, cellBuilder;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTableView];
    [self.tableView reloadData];
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
}

#pragma mark - NewsDetailOutputDelegate

-(void)reloadTableView {
    
}

-(void)failedToGetData {
    
}

@end
