//
//  HistoryItemViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "HistoryItemViewController.h"
#import "GradientViewWithAnimation.h"
#import "HistoryElement.h"
#import "HistoryItemHeaderView.h"
#import "HistoryItemDelegateDataSource.h"

@interface HistoryItemViewController ()

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *topBoeardView;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cointType;
@property (weak, nonatomic) IBOutlet UILabel *receivedTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) HistoryItemDelegateDataSource* historyDelegateDataSource;
@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;
@property (weak, nonatomic) IBOutlet UIView *notConfirmedDesk;

@end

@implementation HistoryItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configWithItem];
    [self configTableView];
    
    [self.pageControl setCurrentPage:0];
    self.notConfirmedDesk.hidden = self.item.confirmed;
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
    self.balanceLabel.text = [NSString stringWithFormat:@"%0.6f",self.item.amount.floatValue];
    self.receivedTimeLabel.text = self.item.fullDateString;
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedPageControllAction:(id)sender {
    
    if (self.pageControl.currentPage == 1) {
        [self.pageControl setCurrentPage:0];
        self.fromToLabel.text = NSLocalizedString(@"From", @"From To Transaction");
        self.historyDelegateDataSource.mode = From;
    } else {
        [self.pageControl setCurrentPage:1];
        self.fromToLabel.text = NSLocalizedString(@"To", @"From To Transaction");
        self.historyDelegateDataSource.mode = To;
    }
    [self.tableView reloadData];
}

@end
