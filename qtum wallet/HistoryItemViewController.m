//
//  HistoryItemViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "HistoryItemViewController.h"
#import "GradientViewWithAnimation.h"
#import "HistoryElement.h"
#import "HistoryItemDelegateDataSource.h"
#import "PageControl.h"

@interface HistoryItemViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cointType;
@property (weak, nonatomic) IBOutlet UILabel *receivedTimeLabel;

@property (weak, nonatomic) IBOutlet UITableView *fromTable;
@property (weak, nonatomic) IBOutlet UITableView *toTable;

@property (weak, nonatomic) IBOutlet UILabel *fromToLabel;
@property (weak, nonatomic) IBOutlet PageControl *pageControl;

@property (strong,nonatomic) HistoryItemDelegateDataSource* fromHistoryTableSource;
@property (strong,nonatomic) HistoryItemDelegateDataSource* toHistoryTableSource;

@end

@implementation HistoryItemViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configWithItem];
    [self configTables];
    
    [self.pageControl setPagesCount:2];
    [self.pageControl setSelectedPage:0];
    
    self.scrollView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)configTables {
    
    self.fromHistoryTableSource = [HistoryItemDelegateDataSource new];
    self.fromHistoryTableSource.item = self.item;
    self.fromHistoryTableSource.mode = From;
    
    self.toHistoryTableSource = [HistoryItemDelegateDataSource new];
    self.toHistoryTableSource.item = self.item;
    self.toHistoryTableSource.mode = To;
    
    self.fromTable.delegate = self.fromHistoryTableSource;
    self.fromTable.dataSource = self.fromHistoryTableSource;
    
    self.toTable.delegate = self.toHistoryTableSource;
    self.toTable.dataSource = self.toHistoryTableSource;
}

- (void)configWithItem {
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%0.6f", self.item.amount.doubleValue];
    self.receivedTimeLabel.text = self.item.fullDateString ?: NSLocalizedString(@"Unconfirmed", nil);
}

- (void)changeCurrentIndex:(NSInteger)index {
    
    [self.pageControl setSelectedPage:index];
    self.fromToLabel.text = (index == 0) ? NSLocalizedString(@"From", @"From To Transaction") : NSLocalizedString(@"To", @"From To Transaction");
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    } else if (scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
    
    if ((NSInteger)scrollView.contentOffset.x % (NSInteger)scrollView.bounds.size.width == 0) {
        
        NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
        [self changeCurrentIndex:index];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
    } else if (scrollView.contentOffset.x >= scrollView.bounds.size.width) {
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
    }
}

@end
