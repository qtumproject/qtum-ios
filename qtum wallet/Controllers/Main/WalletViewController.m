//
//  MainViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "WalletViewController.h"
#import "HistoryTableViewCell.h"
#import "NewPaymentDarkViewController.h"
#import "RecieveViewController.h"
#import "HistoryElement.h"
#import "QRCodeViewController.h"
#import "ApplicationCoordinator.h"
#import "GradientViewWithAnimation.h"
#import "WalletTableSource.h"
#import "WalletCoordinator.h"
#import "HistoryHeaderVIew.h"

@interface WalletViewController ()

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (assign, nonatomic) BOOL balanceLoaded;
@property (assign, nonatomic) BOOL historyLoaded;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;

@property (nonatomic) id<Spendable> wallet;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.isFirstTimeUpdate = YES;
    
    [self configTableView];
    [self configRefreshControl];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    [self reloadHeader:self.wallet];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.isFirstTimeUpdate) {
        [self.delegate didReloadTableViewData];
        self.isFirstTimeUpdate = NO;
    }
}

#pragma mark - Configuration

-(void)configRefreshControl { }

-(void)configTableView{
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self.tableSource;
    self.tableView.delegate = self.tableSource;
    self.tableSource.tableView = self.tableView;
    self.tableSource.controllerDelegate = self;
}

#pragma mark - Private Methods


#pragma mark - Methods

-(void)reloadTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self reloadHeader:self.wallet];
        self.historyLoaded = YES;
        if (self.balanceLoaded && self.historyLoaded) {
            [[PopUpsManager sharedInstance] dismissLoader];
        }
    });
}

- (void)reloadHeader:(id<Spendable>)wallet {
    
    BOOL haveUncorfirmed = wallet.unconfirmedBalance != 0.0f;
    self.availableTextTopConstraint.constant = haveUncorfirmed ? 10.0f : 17.0f;
    self.availableValueTopConstraint.constant = haveUncorfirmed ? 8.0f : 15.0f;
    
    self.unconfirmedTextLabel.hidden =
    self.uncorfirmedLabel.hidden = !haveUncorfirmed;
    
    self.uncorfirmedLabel.text = [NSString stringWithFormat:@"%.3f QTUM", wallet.unconfirmedBalance];
    self.availabelLabel.text = [NSString stringWithFormat:@"%.3f QTUM", wallet.balance];
}

-(void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] showLoaderPopUp];
    });
}

-(void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] dismissLoader];
    });
}

-(void)failedToGetData{
    self.historyLoaded = YES;
}

-(void)failedToGetBalance{
    self.balanceLoaded = YES;
}

- (void)refreshFromRefreshControl {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
    [self.delegate didReloadTableViewData];
}

#pragma mark - Actions

- (IBAction)actionQRCode:(id)sender {
    [self.delegate didShowQRCodeScan];
}

#pragma mark - TableSourceDelegate

- (void)needShowHeader:(CGFloat)percent { }

- (void)needHideHeader:(CGFloat)percent { }

- (void)needShowHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = NO;
}
- (void)needHideHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = YES;
}

@end
