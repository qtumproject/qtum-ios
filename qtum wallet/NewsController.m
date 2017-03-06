//
//  NewsController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 07.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NewsController.h"
#import "NewsCellModel.h"
#import "NewsDataSourceAndDelegate.h"
#import "NewsCoordinator.h"


@interface NewsController ()

@property (strong,nonatomic)UIRefreshControl* refresh;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray <NewsCellModel*> * dataArray;
@property (strong,nonatomic) NewsDataSourceAndDelegate* dataSourceAndDelegate;


@end


@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    [self configPullRefresh];
    
    [self getData];
    
    [SVProgressHUD show];
    self.tableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self endEditing:nil];
}


#pragma mark - Getters


-(NewsDataSourceAndDelegate*)dataSourceAndDelegate{
    if (!_dataSourceAndDelegate) {
        _dataSourceAndDelegate = [NewsDataSourceAndDelegate new];
    }
    return _dataSourceAndDelegate;
}

#pragma mark - Configuration

-(void)configPullRefresh{
    self.refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(actionRefresh) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:self.refresh];
}

-(void)configTableView{
    self.tableView.delegate = self.dataSourceAndDelegate;
    self.tableView.dataSource = self.dataSourceAndDelegate;
}

#pragma mark - Private Methods

-(IBAction)endEditing:(id)sender{
    [self.view endEditing:YES];
}

-(void)getData{
    [SVProgressHUD show];
    [self.delegate refreshTableViewData];
}


-(void)reloadTableView{
    [self reloadTable];
}

-(void)requestFailed{
    [self.refresh endRefreshing];
    [SVProgressHUD dismiss];
}

-(void)reloadTable{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.tableView.hidden = NO;
        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        [weakSelf.refresh endRefreshing];
    });
}


#pragma mark - Actions


-(void)actionRefresh{
    [self getData];
}


@end
