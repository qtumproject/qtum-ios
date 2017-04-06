//
//  HistoryItemViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "HistoryItemViewController.h"
#import "GradientViewWithAnimation.h"
#import "HistoryElement.h"
#import "HistoryItemHeaderView.h"
#import "HistoryItemDelegateDataSource.h"

@interface HistoryItemViewController ()

@property (weak, nonatomic) IBOutlet GradientViewWithAnimation *topBoeardView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cointType;
@property (weak, nonatomic) IBOutlet UILabel *receivedTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) HistoryItemDelegateDataSource* historyDelegateDataSource;

@end

@implementation HistoryItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configWithItem];
    [self configTableView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)configTableView{
    UINib *nib = [UINib nibWithNibName:@"HistoryItemHeaderView" bundle:nil];
    [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:HistoryItemHeaderViewIdentifier];
    self.historyDelegateDataSource = [HistoryItemDelegateDataSource new];
    self.historyDelegateDataSource.item = self.item;
    self.tableView.delegate = self.historyDelegateDataSource;
    self.tableView.dataSource = self.historyDelegateDataSource;
    [self.tableView reloadData];
}

-(void)configWithItem{

    if (self.item.send) {
        self.topBoeardView.colorType = Pink;
    } else {
        self.topBoeardView.colorType = Green;
    }
    
    self.balanceLabel.text = self.item.amount.stringValue;
    self.receivedTimeLabel.text = self.item.fullDateString;
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
