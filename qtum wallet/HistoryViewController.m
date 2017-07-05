//
//  HistoryViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "HistoryViewController.h"
#import "WalletHistoryTableSource.h"
#import "WalletCoordinator.h"


@interface HistoryViewController ()

@property (nonatomic,assign) BOOL historyLoaded;
@property (nonatomic, strong) NSArray *historyArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self.delegateDataSource;
    self.tableView.dataSource = self.delegateDataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self actionRefreshButton:nil];
}

#pragma mark - Actions

- (IBAction)actionRefreshButton:(id)sender
{
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    [self getHistory];
}

#pragma mark - Private Methods

- (void)getHistory{
    self.historyLoaded = NO;
}

#pragma mark - Public Methods

-(void)reloadTableView{
    self.historyLoaded = YES;
    [[PopUpsManager sharedInstance] dismissLoader];
    [self.tableView reloadData];
}

-(void)failedToGetData{
    self.historyLoaded = YES;
    [[PopUpsManager sharedInstance] dismissLoader];
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Some error", "Tabs")];
}


@end
