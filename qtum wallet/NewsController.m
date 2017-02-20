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


@interface NewsController ()

@property (strong,nonatomic)UIRefreshControl* refresh;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray <NewsCellModel*> * dataArray;
@property (strong,nonatomic) NewsDataSourceAndDelegate* dataSourceAndDelegate;


@end

static NSInteger firstCellHeight = 325;
static NSInteger cellHeight = 100;

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

-(void)parceResponse:(id)response{
    if (!response || ![response isKindOfClass:[NSArray class]]) { return; }
    NSMutableArray* dataArray = @[].mutableCopy;
    for (id item in response) {
        NewsCellModel* object = [[NewsCellModel alloc] initWithDict:item];
        [dataArray addObject:object];
    }
    self.dataSourceAndDelegate.dataArray = dataArray;
    [self reloadTable];
}

-(void)getData{
    __weak __typeof(self) weakSelf = self;
    [[RequestManager sharedInstance] getNews:^(id responseObject) {
        [weakSelf parceResponse:responseObject];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf requestFailed];
//        [UIAlertController showMessageWithTitle:@"Error" andMessage:@"Cant get data"];
    }];
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
