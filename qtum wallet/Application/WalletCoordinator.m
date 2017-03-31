//
//  WalletCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletCoordinator.h"
#import "MainViewController.h"
#import "WalletHistoryDelegateDataSource.h"
#import "BlockchainInfoManager.h"
#import "TabBarCoordinator.h"
#import "HistoryAndBalanceDataStorage.h"


@interface WalletCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) MainViewController* historyController;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;

@end

@implementation WalletCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _isFirstTimeUpdate = YES;
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Coordinatorable

-(void)start{
    MainViewController* controller = (MainViewController*)self.navigationController.viewControllers[0];
    controller.delegate = self;
    self.delegateDataSource = [WalletHistoryDelegateDataSource new];
    self.delegateDataSource.historyArray = @[];
    controller.delegateDataSource = self.delegateDataSource;
    self.historyController = controller;
    [self subcribeEvents];
}

#pragma mark - WalletCoordinatorDelegate

-(void)refreshTableViewDataLocal:(BOOL)isLocal{
    if (self.isFirstTimeUpdate) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.delegateDataSource.historyArray = [responseObject copy];
                    [weakSelf.historyController reloadTableView];
                    weakSelf.isFirstTimeUpdate = NO;
                });
            } andFailureHandler:^(NSError *error, NSString *message) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.historyController failedToGetData];
                });
            }];
        });
    } else {
        self.delegateDataSource.historyArray = [[HistoryAndBalanceDataStorage sharedInstance] getHistory];
        [self.historyController reloadTableView];
    }
}

-(void)refreshTableViewBalanceLocal:(BOOL)isLocal{
    if (isLocal) {
        self.historyController.wigetBalanceLabel.text =
        self.historyController.balanceLabel.text = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        [self.historyController setBalance];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [BlockchainInfoManager getBalanceForAllAddresesWithSuccessHandler:^(double responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.historyController.wigetBalanceLabel.text =
                    weakSelf.historyController.balanceLabel.text = [NSString stringWithFormat:@"%lf", responseObject];
                    [weakSelf.historyController setBalance];
                });
            } andFailureHandler:^(NSError *error, NSString *message) {
                [weakSelf.historyController failedToGetBalance];
            }];
        });
    }
}

-(void)qrCodeScannedWithDict:(NSDictionary*) dict{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate createPaymentFromWalletScanWithDict:dict];
}

#pragma mark - Private Methods

-(void)subcribeEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHistory) name:HistoryUpdateEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBalance) name:BalanceUpdateEvent object:nil];
}

-(void)updateHistory{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.delegateDataSource.historyArray = [[HistoryAndBalanceDataStorage sharedInstance] getHistory];
        [weakSelf.historyController reloadTableView];
    });
}

-(void)updateBalance{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.historyController.wigetBalanceLabel.text = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        weakSelf.historyController.balanceLabel.text = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        [weakSelf.historyController setBalance];
    });
}

@end
