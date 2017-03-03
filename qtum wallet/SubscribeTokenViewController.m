//
//  SubscribeTokenViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataSourceDelegate.h"
#import "SubscribeTokenCoordinator.h"

@interface SubscribeTokenViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) id <UITableViewDataSource,UITableViewDelegate> delegateDataSource;

@end

@implementation SubscribeTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configuration

-(void)configTableView{
    self.tableView.dataSource = self.delegateDataSource;
    self.tableView.delegate = self.delegateDataSource;
}

#pragma mark - Accesers 

-(id<UITableViewDataSource,UITableViewDelegate>)delegateDataSource{
    if (!_delegateDataSource) {
        _delegateDataSource = [SubscribeTokenDataSourceDelegate new];
    }
    return _delegateDataSource;
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackButtonPressed];
}

@end
