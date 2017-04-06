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
#import "WalletTypeCollectionDataSourceDelegate.h"
#import "WalletModel.h"
#import "RecieveViewController.h"
#import "HistoryItemViewController.h"


@interface WalletCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) MainViewController* historyController;
@property (strong, nonatomic) WalletModel* wallet;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;
@property (strong,nonatomic) WalletTypeCollectionDataSourceDelegate* collectionDelegateDataSource;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;
@property (assign, nonatomic) NSInteger pageNumber;
@property (strong, nonatomic) dispatch_queue_t requestQueue;
@property (assign,nonatomic)BOOL isNewDataLoaded;

@end

@implementation WalletCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _isFirstTimeUpdate = YES;
        _isNewDataLoaded = YES;
        _requestQueue = dispatch_queue_create("com.pixelplex.requestQueue", DISPATCH_QUEUE_SERIAL);
        [self subcribeEvents];
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
    
    [self configWalletModel];
    self.collectionDelegateDataSource = [WalletTypeCollectionDataSourceDelegate new];
    self.collectionDelegateDataSource.wallet = self.wallet;
    self.collectionDelegateDataSource.delegate = self;
    self.delegateDataSource = [WalletHistoryDelegateDataSource new];
    self.delegateDataSource.delegate = self;
    self.delegateDataSource.wallet = self.wallet;
    self.delegateDataSource.collectionDelegateDataSource = self.collectionDelegateDataSource;
    controller.delegateDataSource = self.delegateDataSource;
    self.historyController = controller;
}

#pragma mark - WalletCoordinatorDelegate

-(void)viewWillAppear{
//    [self.historyController reloadTableView];
}

-(void)showAddressInfo{
    RecieveViewController *vc = [[ControllersFactory sharedInstance] createRecieveViewController];
    vc.walletModel = self.wallet;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)reloadTableViewData{
    if (self.isNewDataLoaded) {
        [self reloadHistory];
    }
}

- (void)refreshTableViewData{
    if (self.isNewDataLoaded) {
        [self refreshHistory];
    }
}

-(void)refreshTableViewBalanceLocal:(BOOL)isLocal{
    if (isLocal) {
        self.delegateDataSource.wallet.balance = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        [self.historyController setBalance];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(_requestQueue, ^{
            [weakSelf.historyController startLoading];
            [BlockchainInfoManager getBalanceForAllAddresesWithSuccessHandler:^(double responseObject) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.delegateDataSource.wallet.balance = [NSString stringWithFormat:@"%lf", responseObject];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item{
    HistoryItemViewController* controller = (HistoryItemViewController*)[[ControllersFactory sharedInstance] createHistoryItem];
    controller.item = item;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item{
    
}

#pragma mark - Configuration

-(void)configWalletModel{
    self.wallet = [WalletModel new];
    self.wallet.historyArray = @[];
    NSString* keyString = [AppSettings sharedInstance].isMainNet ? [WalletManager sharedInstance].getCurrentWallet.getRandomKey.address.string : [WalletManager sharedInstance].getCurrentWallet.getRandomKey.addressTestnet.string;
    self.wallet.activeAddress = keyString;
}

#pragma mark - Private Methods

-(void)refreshHistory{
    __weak typeof(self) weakSelf = self;
    
    self.isNewDataLoaded = NO;
    dispatch_async(_requestQueue, ^{
        
        [weakSelf.historyController startLoading];
        weakSelf.pageNumber ++;
        [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HistoryAndBalanceDataStorage sharedInstance] addHistoryElements:responseObject];
                weakSelf.isNewDataLoaded = YES;
            });
            weakSelf.pageNumber++;
            weakSelf.isFirstTimeUpdate = NO;
        } andFailureHandler:^(NSError *error, NSString *message) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.historyController failedToGetData];
                weakSelf.isNewDataLoaded = YES;
            });
        } andParam:@{@"limit" : @25,
                     @"offset" : @(weakSelf.pageNumber * 25)}];
    });
}

-(void)reloadHistory{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_requestQueue, ^{
        [weakSelf.historyController startLoading];
        weakSelf.pageNumber = 0;
        [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[HistoryAndBalanceDataStorage sharedInstance] setHistory:responseObject];
                weakSelf.isNewDataLoaded = YES;
            });
            weakSelf.isFirstTimeUpdate = NO;
        } andFailureHandler:^(NSError *error, NSString *message) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.historyController failedToGetData];
                weakSelf.isNewDataLoaded = YES;
            });
        } andParam:@{@"limit" : @25,
                     @"offset" : @(weakSelf.pageNumber * 25)}];
    });
}


-(void)subcribeEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHistory) name:HistoryUpdateEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBalance) name:BalanceUpdateEvent object:nil];
}

-(void)updateHistory{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.delegateDataSource.wallet.historyArray = [[HistoryAndBalanceDataStorage sharedInstance] historyPrivate];
        [weakSelf.historyController reloadTableView];
    });
}

-(void)updateBalance{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
         weakSelf.delegateDataSource.wallet.balance = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        [weakSelf.historyController setBalance];
    });
}



@end
