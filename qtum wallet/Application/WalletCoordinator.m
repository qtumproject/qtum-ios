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
#import "TokenModel.h"
#import "RecieveViewController.h"
#import "HistoryItemViewController.h"
#import "Walletable.h"


@interface WalletCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) MainViewController* historyController;
@property (strong, nonatomic) NSMutableArray <Walletable>* wallets;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;
@property (strong,nonatomic) WalletTypeCollectionDataSourceDelegate* collectionDelegateDataSource;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;
@property (assign, nonatomic) NSInteger pageHistoryNumber;
@property (assign, nonatomic) NSInteger pageWallet;
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
    
    [self configWalletModels];
    self.collectionDelegateDataSource = [WalletTypeCollectionDataSourceDelegate new];
    self.collectionDelegateDataSource.wallets = self.wallets;
    self.collectionDelegateDataSource.delegate = self;
    self.delegateDataSource = [WalletHistoryDelegateDataSource new];
    self.delegateDataSource.delegate = self;
    self.delegateDataSource.wallet = self.wallets[self.pageWallet];
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
    vc.walletModel = self.wallets[self.pageWallet];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pageDidChange:(NSInteger)page{
    if (self.pageWallet != page) {
        self.pageWallet = page;
        self.delegateDataSource.wallet = self.wallets[self.pageWallet];
        [self.historyController reloadHistorySection];
    }
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
    if (self.pageWallet == 0) {
        if (isLocal) {
            id <Walletable> wallet = self.wallets[0];
            wallet.balance = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
            [self.historyController setBalance];
        } else {
            __weak typeof(self) weakSelf = self;
            dispatch_async(_requestQueue, ^{
                [weakSelf.historyController startLoading];
                [BlockchainInfoManager getBalanceForAllAddresesWithSuccessHandler:^(double responseObject) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        id <Walletable> wallet = weakSelf.wallets[0];
                        wallet.balance = [NSString stringWithFormat:@"%lf", responseObject];
                        [weakSelf.historyController setBalance];
                    });
                } andFailureHandler:^(NSError *error, NSString *message) {
                    [weakSelf.historyController failedToGetBalance];
                }];
            });
        }
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

-(void)configWalletModels{
    self.wallets = @[].mutableCopy;
    WalletModel* wallet = [WalletModel new];
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? [WalletManager sharedInstance].getCurrentWallet.getRandomKey.address.string : [WalletManager sharedInstance].getCurrentWallet.getRandomKey.addressTestnet.string;
    wallet.historyArray = [HistoryAndBalanceDataStorage sharedInstance].historyPrivate;
    wallet.activeAddress = keyString;
    wallet.balance =  [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
    wallet.signature = @"QTUM";
    [self.wallets addObject:wallet];
    for (Token* token in [WalletManager sharedInstance].gatAllTokens) {
        TokenModel* model  = [TokenModel new];
        model.signature = token.symbol;
        model.balance = [NSString stringWithFormat:@"%0.6f",token.balance];
        model.historyArray = @[];
        [self.wallets addObject:model];
    }
}

-(void)setWalletsToDelegates {
    
    self.collectionDelegateDataSource.wallets = self.wallets;
    self.delegateDataSource.wallet = self.wallets[self.pageWallet];
}

#pragma mark - Private Methods

-(void)refreshHistory{
    if (self.pageWallet == 0) {
        __weak typeof(self) weakSelf = self;
        
        self.isNewDataLoaded = NO;
        dispatch_async(_requestQueue, ^{
            
            [weakSelf.historyController startLoading];
            weakSelf.pageHistoryNumber ++;
            [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[HistoryAndBalanceDataStorage sharedInstance] addHistoryElements:responseObject];
                    weakSelf.isNewDataLoaded = YES;
                });
                weakSelf.pageHistoryNumber++;
                weakSelf.isFirstTimeUpdate = NO;
            } andFailureHandler:^(NSError *error, NSString *message) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.historyController failedToGetData];
                    weakSelf.isNewDataLoaded = YES;
                });
            } andParam:@{@"limit" : @25,
                         @"offset" : @(weakSelf.pageHistoryNumber * 25)}];
        });
    }
}

-(void)reloadHistory{
    if (self.pageWallet == 0) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(_requestQueue, ^{
            [weakSelf.historyController startLoading];
            weakSelf.pageHistoryNumber = 0;
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
                         @"offset" : @(weakSelf.pageHistoryNumber * 25)}];
        });
    }
}


-(void)subcribeEvents{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHistory) name:HistoryUpdateEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBalance) name:BalanceUpdateEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokens) name:TokenUpdateEvent object:nil];

}

-(void)updateHistory{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        id <Walletable> wallet = weakSelf.wallets[0];
        wallet.historyArray = [[HistoryAndBalanceDataStorage sharedInstance] historyPrivate];
        [weakSelf.historyController reloadTableView];
    });
}

-(void)updateBalance{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        id <Walletable> wallet = weakSelf.wallets[0];
        wallet.balance = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
        [weakSelf.historyController setBalance];
    });
}

-(void)updateTokens{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf configWalletModels];
        [weakSelf setWalletsToDelegates];
        [weakSelf.historyController reloadTableView];
    });
}

@end
