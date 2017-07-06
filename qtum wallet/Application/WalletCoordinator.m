//
//  WalletCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletCoordinator.h"

#import "WalletOutput.h"

#import "WalletTableSource.h"
#import "TabBarCoordinator.h"
#import "HistoryDataStorage.h"
#import "RecieveViewController.h"
#import "HistoryItemViewController.h"
#import "Spendable.h"
#import "TokenDetailsViewController.h"
#import "TokenDetailsTableSource.h"
#import "QRCodeViewController.h"

#import "BalancePageViewController.h"
#import "WalletNavigationController.h"
#import "TokenListViewController.h"
#import "TokenFunctionViewController.h"
#import "ContractInterfaceManager.h"
#import "TokenFunctionDetailViewController.h"
#import "ResultTokenInputsModel.h"
#import "ContractArgumentsInterpretator.h"
#import "NSString+Extension.h"
#import "TransactionManager.h"

@interface WalletCoordinator () <TokenListViewControllerDelegate, QRCodeViewControllerDelegate, WalletOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) BalancePageViewController* pageViewController;
@property (weak, nonatomic) NSObject<WalletOutput> *walletViewController;
@property (weak, nonatomic) TokenListViewController* tokenController;
@property (weak, nonatomic) TokenDetailsViewController *tokenDetailsViewController;

@property (assign, nonatomic) BOOL isNewDataLoaded;
@property (assign, nonatomic) BOOL isBalanceLoaded;
@property (assign, nonatomic) BOOL isHistoryLoaded;

@property (strong, nonatomic) id<Spendable> wallet;
@property (strong, nonatomic) dispatch_queue_t requestQueue;

@property (strong, nonatomic) WalletTableSource* delegateDataSource;
@property (strong, nonatomic) TokenDetailsTableSource *tokenDetailsTableSource;

@end

@implementation WalletCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _isNewDataLoaded = YES;
        _requestQueue = dispatch_queue_create("com.pixelplex.requestQueue", DISPATCH_QUEUE_SERIAL);
        [self subcribeEvents];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)didQRCodeScannedWithDict:(NSDictionary *)dict {
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate createPaymentFromWalletScanWithDict:dict];
}

#pragma mark - Coordinatorable

-(void)start{
    
    NSObject<WalletOutput> *controller = [[ControllersFactory sharedInstance] createWalletViewController];
    controller.delegate = self;
    
    [self configWallet];
    [controller setWallet:self.wallet];
    self.delegateDataSource = [[TableSourcesFactory sharedInstance] createWalletSource];
    self.delegateDataSource.delegate = self;
    self.delegateDataSource.wallet = self.wallet;
    self.delegateDataSource.haveTokens = [[ContractManager sharedInstance] allActiveTokens].count > 0;
    controller.tableSource = self.delegateDataSource;
    self.walletViewController = controller;
    
    TokenListViewController* tokenController = (TokenListViewController*)[[ControllersFactory sharedInstance] createTokenListViewController];
    tokenController.tokens = [[ContractManager sharedInstance] allActiveTokens];
    tokenController.delegate = self;
    controller.delegate = self;
    self.tokenController = tokenController;
    
    self.pageViewController = self.navigationController.viewControllers[0];
    self.pageViewController.controllers = @[controller,tokenController];
    [self.pageViewController setScrollEnable:[[ContractManager sharedInstance] allTokens].count > 0];
}

#pragma mark - WalletCoordinatorDelegate

-(void)showAddressInfoWithSpendable:(id <Spendable>) spendable{
    
    RecieveViewController *vc = [[ControllersFactory sharedInstance] createRecieveViewController];
    vc.wallet = spendable;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)showTokenDetails {
    
    TokenDetailsViewController *vc = [[ControllersFactory sharedInstance] createTokenDetailsViewController];
    self.tokenDetailsViewController = vc;
    self.tokenDetailsTableSource = [TokenDetailsTableSource new];
    vc.delegate = self;
    [vc setTableSource:self.tokenDetailsTableSource];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshTableViewData{
    if (self.isNewDataLoaded) {
        [self refreshHistory];
    }
}

- (void)didSelectHistoryItemIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item {
    
    HistoryItemViewController* controller = (HistoryItemViewController*)[[ControllersFactory sharedInstance] createHistoryItem];
    controller.item = item;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item{

    TokenDetailsViewController *vc = [[ControllersFactory sharedInstance] createTokenDetailsViewController];
    self.tokenDetailsViewController = vc;
    self.tokenDetailsTableSource = [TokenDetailsTableSource new];
    vc.delegate = self;
    vc.token = item;
    [vc setTableSource:self.tokenDetailsTableSource];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Configuration

-(void)configWallet{
    self.wallet = [WalletManager sharedInstance].currentWallet;
}

-(void)setWalletToDelegates {
    self.delegateDataSource.wallet = self.wallet;
    [self.walletViewController setWallet:self.wallet];
}

#pragma mark - Private Methods

-(void)refreshHistory {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        [weakSelf.walletViewController startLoading];
        weakSelf.isHistoryLoaded = NO;
        id <Spendable> spendable = (id<Spendable>)(weakSelf.wallet);
        NSInteger index = spendable.historyStorage.pageIndex + 1; //next page
        [weakSelf.wallet updateHistoryWithHandler:^(BOOL success) {
            weakSelf.isHistoryLoaded = YES;
            if (success) {
                [weakSelf.walletViewController reloadTableView];
            }
            [weakSelf stopRefreshing];
        } andPage:index];
    });
}

-(void)reloadHistory {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        [weakSelf.walletViewController startLoading];
        weakSelf.isHistoryLoaded = NO;
        [weakSelf.wallet updateHistoryWithHandler:^(BOOL success) {
            weakSelf.isHistoryLoaded = YES;
            if (success) {
                [weakSelf.walletViewController reloadTableView];
            }
            [weakSelf stopRefreshing];
        } andPage:0];
    });
}

-(void)stopRefreshing{
    
    if (self.isBalanceLoaded && self.isHistoryLoaded) {
        [self.walletViewController stopLoading];
    }
}

-(void)subcribeEvents{

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSpendables) name:kWalletDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTokens) name:kTokenDidChange object:nil];
}

-(void)updateSpendables {
    
    NSArray *tokensArray = [[ContractManager sharedInstance] allActiveTokens];
    self.delegateDataSource.haveTokens = tokensArray.count > 0;
    [self.walletViewController reloadTableView];
    self.tokenController.tokens = tokensArray;
    [self.tokenController reloadTable];
    
    if (tokensArray.count == 0) {
        [self.pageViewController scrollToRootIfNeededAnimated:YES];
    } else {
        [self.pageViewController setScrollingToTokensAvailableIfNeeded];
    }
}

-(void)updateTokens{
    
    [self configWallet];
    [self setWalletToDelegates];
    [self updateSpendables];
}

- (void)didBackPressed{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WalletOutputDelegate

- (void)didShowQRCodeScan {
    QRCodeViewController *vc = [[ControllersFactory sharedInstance] createQRCodeViewControllerForWallet];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)didRefreshTableViewBalanceLocal:(BOOL)isLocal {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(_requestQueue, ^{
        weakSelf.isBalanceLoaded = NO;
        [weakSelf.walletViewController startLoading];
        [weakSelf.wallet updateBalanceWithHandler:^(BOOL success) {
            
            weakSelf.isBalanceLoaded = YES;
            if (success) {
                [weakSelf.walletViewController reloadTableView];
            }
            [weakSelf stopRefreshing];
        }];
    });
}

- (void)didReloadTableViewData{
    if (self.isNewDataLoaded) {
        [self didRefreshTableViewBalanceLocal:NO];
        [self reloadHistory];
    }
}

@end
