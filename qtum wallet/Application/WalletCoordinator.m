//
//  WalletCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletCoordinator.h"
#import "MainViewController.h"
#import "WalletHistoryDelegateDataSource.h"
#import "TabBarCoordinator.h"
#import "HistoryDataStorage.h"
#import "WalletTypeCollectionDataSourceDelegate.h"
#import "RecieveViewController.h"
#import "HistoryItemViewController.h"
#import "Spendable.h"


@interface WalletCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) MainViewController* historyController;
@property (strong, nonatomic) NSMutableArray <Spendable>* wallets;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;
@property (strong,nonatomic) WalletTypeCollectionDataSourceDelegate* collectionDelegateDataSource;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;
@property (assign, nonatomic) NSInteger pageHistoryNumber;
@property (assign, nonatomic) NSInteger pageWallet;
@property (strong, nonatomic) dispatch_queue_t requestQueue;
@property (assign,nonatomic)BOOL isNewDataLoaded;
@property (assign,nonatomic)BOOL isBalanceLoaded;
@property (assign,nonatomic)BOOL isHistoryLoaded;


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
    vc.wallet = self.wallets[self.pageWallet];
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
        [self refreshTableViewBalanceLocal:NO];
        [self reloadHistory];
    }
}

- (void)refreshTableViewData{
    if (self.isNewDataLoaded) {
        [self refreshHistory];
    }
}

-(void)refreshTableViewBalanceLocal:(BOOL)isLocal{
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        weakSelf.isBalanceLoaded = NO;
        [weakSelf.historyController startLoading];
        [weakSelf.wallets[weakSelf.pageWallet] updateBalanceWithHandler:^(BOOL success) {
            
            weakSelf.isBalanceLoaded = YES;
            if (success) {
                [weakSelf.historyController reloadTableView];
            }
            [weakSelf stopRefreshing];
        }];
    });
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
    [self.wallets addObject:[WalletManager sharedInstance].getCurrentWallet];
    [self.wallets addObjectsFromArray:[TokenManager sharedInstance].gatAllTokens];
}

-(void)setWalletsToDelegates {
    
    self.collectionDelegateDataSource.wallets = self.wallets;
    self.delegateDataSource.wallet = self.wallets[self.pageWallet];
}

#pragma mark - Private Methods

-(void)refreshHistory{
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        [weakSelf.historyController startLoading];
        weakSelf.isHistoryLoaded = NO;
        id <Spendable> spendable = (id<Spendable>)(weakSelf.wallets[weakSelf.pageWallet]);
        NSInteger index = spendable.historyStorage.pageIndex + 1; //next page
        [weakSelf.wallets[weakSelf.pageWallet] updateHistoryWithHandler:^(BOOL success) {
            weakSelf.isHistoryLoaded = YES;
            if (success) {
                [weakSelf.historyController reloadTableView];
            }
            [weakSelf stopRefreshing];
        } andPage:index];
    });
}

-(void)reloadHistory{
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        [weakSelf.historyController startLoading];
        weakSelf.isHistoryLoaded = NO;
        [weakSelf.wallets[weakSelf.pageWallet] updateHistoryWithHandler:^(BOOL success) {
            weakSelf.isHistoryLoaded = YES;
            if (success) {
                [weakSelf.historyController reloadTableView];
            }
            [weakSelf stopRefreshing];
        } andPage:0];
    });
}

-(void)stopRefreshing{
    if (self.isBalanceLoaded && self.isHistoryLoaded) {
        [self.historyController stopLoading];
    }
}


-(void)subcribeEvents{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpendables) name:kWalletDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokens) name:kTokenDidChange object:nil];
}

-(void)updateSpendables{
    [self.historyController reloadTableView];
}

-(void)updateBalance{
//    __weak __typeof(self)weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        id <Walletable> wallet = weakSelf.wallets[0];
//        wallet.balance = [NSString stringWithFormat:@"%lf", [HistoryAndBalanceDataStorage sharedInstance].balance];
//        [weakSelf.historyController setBalance];
//    });
}

-(void)updateTokens{
    [self configWalletModels];
    [self setWalletsToDelegates];
    [self updateSpendables];
}

@end
