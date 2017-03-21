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


@interface WalletCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) MainViewController* historyController;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;

@end

@implementation WalletCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    MainViewController* controller = (MainViewController*)self.navigationController.viewControllers[0];
    controller.delegate = self;
    self.delegateDataSource = [WalletHistoryDelegateDataSource new];
    self.delegateDataSource.historyArray = @[];
    controller.delegateDataSource = self.delegateDataSource;
    self.historyController = controller;
}

#pragma mark - WalletCoordinatorDelegate

-(void)refreshTableViewData{
    __weak typeof(self) weakSelf = self;
    [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
        weakSelf.delegateDataSource.historyArray = responseObject;
        [weakSelf.historyController reloadTableView];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf.historyController failedToGetData];
    }];
}

-(void)refreshTableViewBalance{
    __weak typeof(self) weakSelf = self;
    [BlockchainInfoManager getBalanceForAllAddresesWithSuccessHandler:^(double responseObject) {
        weakSelf.historyController.wigetBalanceLabel.text =
        weakSelf.historyController.balanceLabel.text = [NSString stringWithFormat:@"%lf", responseObject];
        [weakSelf.historyController setBalance];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf.historyController failedToGetBalance];
    }];
}

-(void)qrCodeScannedWithDict:(NSDictionary*) dict{
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate createPaymentFromWalletScanWithDict:dict];
}

@end
