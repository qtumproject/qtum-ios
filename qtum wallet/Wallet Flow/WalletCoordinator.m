//
//  WalletCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletCoordinator.h"

#import "WalletOutput.h"
#import "BalancePageOutput.h"
#import "TokenListOutput.h"
#import "HistoryItemOutput.h"
#import "RecieveOutput.h"

#import "WalletTableSource.h"
#import "TabBarCoordinator.h"
#import "TokenDetailsViewController.h"
#import "QRCodeViewController.h"
#import "ShareTokenPopUpViewController.h"

#import "WalletManager.h"
#import "AddressLibruaryCoordinator.h"
#import "TokenAddressLibraryCoordinator.h"
#import "ChooseReciveAddressOutput.h"
#import "ErrorPopUpViewController.h"


@interface WalletCoordinator () <TokenListOutputDelegate, QRCodeOutputDelegate, WalletOutputDelegate, HistoryItemOutputDelegate, RecieveOutputDelegate, ShareTokenPopupViewControllerDelegate, PopUpViewControllerDelegate, TokenDetailOutputDelegate, AddressLibruaryCoordinatorDelegate, TokenAddressLibraryCoordinatorDelegate, ChooseReciveAddressOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) NSObject <BalancePageOutput> *pageViewController;
@property (weak, nonatomic) NSObject <WalletOutput> *walletViewController;
@property (weak, nonatomic) NSObject <TokenListOutput> *tokenController;
@property (weak, nonatomic) NSObject <TokenDetailOutput> *tokenDetailsViewController;
@property (weak, nonatomic) NSObject <RecieveOutput> *reciveOutput;

@property (assign, nonatomic) BOOL isNewDataLoaded;
@property (assign, nonatomic) BOOL isBalanceLoaded;
@property (assign, nonatomic) BOOL isHistoryLoaded;
@property (assign, nonatomic) BOOL isFailedConnection;

@property (strong, nonatomic) id <Spendable> wallet;
@property (strong, nonatomic) dispatch_queue_t requestQueue;

@property (strong, nonatomic) WalletTableSource *delegateDataSource;
@property (strong, nonatomic) id <TokenDetailDataDisplayManager> tokenDetailsTableSource;

@property (strong, nonatomic) NSTimer *historyElementsTimerUpdate;
@property (assign, nonatomic) NSInteger firesTimerCount;

@end

static const CGFloat blanceRoundingCount = 8;


@implementation WalletCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController {
	self = [super init];
	if (self) {
		_navigationController = navigationController;
		_isNewDataLoaded = YES;
		_requestQueue = dispatch_queue_create ("org.qtum.requestQueue", DISPATCH_QUEUE_SERIAL);
		[self subcribeEvents];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - QRCodeOutputDelegate

- (void)didQRCodeScannedWithSendInfoItem:(SendInfoItem *) item {

	[self.navigationController popViewControllerAnimated:NO];
	[self.delegate createPaymentFromSendInfoItem:item];
}

#pragma mark - Coordinatorable

- (void)start {

	NSObject <WalletOutput> *controller = [SLocator.controllersFactory createWalletViewController];
	controller.delegate = self;

	[self configWallet];
	[controller setWallet:self.wallet];
	self.delegateDataSource = [SLocator.tableSourcesFactory createWalletSource];
	self.delegateDataSource.delegate = self;
	self.delegateDataSource.wallet = self.wallet;
	self.delegateDataSource.haveTokens = [SLocator.contractManager allActiveTokens].count > 0;
	controller.tableSource = self.delegateDataSource;
	self.walletViewController = controller;

	NSObject <TokenListOutput> *tokenController = [SLocator.controllersFactory createTokenListViewController];
	tokenController.tokens = [SLocator.contractManager allActiveTokens];
	tokenController.delegate = self;
	controller.delegate = self;
	self.tokenController = tokenController;

	self.pageViewController = (NSObject <BalancePageOutput> *)self.navigationController.viewControllers[0];
	self.pageViewController.controllers = @[controller, tokenController];
	[self.pageViewController setScrollEnable:[SLocator.contractManager allActiveTokens].count > 0];
}

#pragma mark - WalletCoordinatorDelegate

- (void)refreshTableViewDataWithPage:(NSInteger) page {

	if (self.isNewDataLoaded) {
        [self refreshHistoryWithPage:page];
	}
}

-(void)refreshTableViewDataFromStart {
    
    [self fireHistoryElementTimerUpdate];
    [self reloadHistory];
}

- (void)didSelectHistoryItemIndexPath:(NSIndexPath *) indexPath withItem:(id <HistoryElementProtocol> ) item {

	NSObject <HistoryItemOutput> *controller = [SLocator.controllersFactory createHistoryItem];
    TransactionReceipt* reciept = [SLocator.historyFacadeService getRecieptWithTxHash:item.transactionHash];
	controller.item = item;
    controller.receipt = reciept;
	controller.delegate = self;
    controller.logs = [SLocator.historyFacadeService getLogsDTOSWithReceit:reciept];
	[self.navigationController pushViewController:[controller toPresent] animated:YES];
}

#pragma mark - TokenListOutputDelegate

- (void)didSelectTokenIndexPath:(NSIndexPath *) indexPath withItem:(Contract *) item {

	NSObject <TokenDetailOutput> *output = [SLocator.controllersFactory createTokenDetailsViewController];
	self.tokenDetailsViewController = output;
	self.tokenDetailsTableSource = [SLocator.tableSourcesFactory createTokenDetailSource];
	self.tokenDetailsTableSource.token = item;
	output.token = item;
	output.delegate = self;
	output.source = self.tokenDetailsTableSource;
	[self.navigationController pushViewController:[output toPresent] animated:YES];
    
    [SLocator.popupService showLoaderPopUp];
    
    __weak typeof (output) weakOutput = output;
    
    [SLocator.callContractFacadeService checkContractWithAddress:item.contractAddress andHandler:^(BOOL exist, NSError *error) {
        if (!error && !exist) {
            [weakOutput showUnsubscribeContractScreen];
        }
        [SLocator.popupService dismissLoader];
    }];
}

- (void)didSelectUnsupportedTokenTokenIndexPath:(NSIndexPath *) indexPath withItem:(Contract *) item {
    
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    
    content.messageString = NSLocalizedString(@"Sorry, this token exceeds the limit of 128 decimals. So it can not be supported in QTUM app", @"Unsupported token message");
    content.titleString = NSLocalizedString(@"Failed", nil);
    
    ErrorPopUpViewController *popUp = [SLocator.popupService showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
}

#pragma mark - TokenDetailOutputDelegate


- (void)showAddressInfoWithSpendable:(id <Spendable>) spendable {

	NSObject <RecieveOutput> *vc = [SLocator.controllersFactory createRecieveViewController];

	if ([spendable isKindOfClass:[Contract class]]) {

		Contract *contract = (Contract *)spendable;
		vc.walletAddress = SLocator.walletManager.wallet.mainAddress;
		vc.type = ReciveTokenOutput;
		vc.tokenAddress = spendable.mainAddress;
		vc.currency = spendable.symbol;

		vc.balanceText = contract.balanceString;
		vc.unconfirmedBalanceText = @"0";
		vc.shortBalanceText = contract.shortBalanceString;

	} else {

		vc.walletAddress = spendable.mainAddress;
		vc.type = ReciveWalletOutput;
		vc.tokenAddress = nil;

		vc.balanceText = [NSString stringWithFormat:@"%@", [SLocator.walletBalanceFacadeService.lastBalance roundedNumberWithScale:blanceRoundingCount]];
		vc.unconfirmedBalanceText = [NSString stringWithFormat:@"%@", [SLocator.walletBalanceFacadeService.lastUnconfirmedBalance roundedNumberWithScale:blanceRoundingCount]];
	}

	vc.delegate = self;
	self.reciveOutput = vc;
	[self.navigationController pushViewController:[vc toPresent] animated:YES];
}

- (void)didBackPressed {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didShareTokenButtonPressed {

	ShareTokenPopUpViewController *vc = [SLocator.popupService showShareTokenPopUp:self presenter:nil completion:nil];
	vc.addressString = self.tokenDetailsViewController.token.contractAddress;
	NSArray *arr = [SLocator.contractFileManager abiWithTemplate:self.tokenDetailsViewController.token.templateModel.path];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
	NSString *abiString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	vc.abiString = abiString;
}

- (void)didShowTokenAddressControlWith:(Contract *) contract {

	[self showTokenAddressControlFlowWith:contract];
}

- (void)didPullToUpdateToken:(Contract *) token {

    [SLocator.popupService showLoaderPopUp];
    
    __block BOOL infoUpdated = NO;
    __block BOOL historyUpdated = NO;
    
    [token updateWithHandler:^(BOOL success) {
        infoUpdated = YES;
        
        if (historyUpdated && infoUpdated) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SLocator.popupService dismissLoader];
            });
        }
    }];
    
    [token updateHistoryWithHandler:^(BOOL success) {
        
        historyUpdated = YES;
        
        if (historyUpdated && infoUpdated) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SLocator.popupService dismissLoader];
            });
        }
        
    } andPage:0];
}

- (void)didSelectTokenHistoryItem:(id <HistoryElementProtocol>) item {
    
    NSObject <HistoryItemOutput> *controller = [SLocator.controllersFactory createHistoryItem];
    controller.item = item;
    controller.delegate = self;
    TransactionReceipt* reciept = [SLocator.historyFacadeService getRecieptWithTxHash:item.transactionHash];
    controller.receipt = reciept;
    controller.logs = [SLocator.historyFacadeService getLogsDTOSWithReceit:reciept];
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didUnsubscribeFromDeletedContract:(Contract *) token {
    
    [SLocator.contractManager removeContract:token];
    [self.navigationController popViewControllerAnimated:YES];
    [self updateTokensList];
}

#pragma mark - Configuration

- (void)configWallet {

	self.wallet = (id <Spendable>)SLocator.walletManager.wallet;
}

- (void)setWalletToDelegates {

	self.delegateDataSource.wallet = self.wallet;
	[self.walletViewController setWallet:self.wallet];
}

#pragma mark - Private Methods

- (void)refreshHistoryWithPage:(NSInteger) page {

	__weak __typeof (self) weakSelf = self;
	dispatch_async (_requestQueue, ^{
		weakSelf.isHistoryLoaded = NO;
		NSInteger index = page; //next page
		[weakSelf.wallet updateHistoryWithHandler:^(BOOL success) {
			weakSelf.isHistoryLoaded = YES;
			if (success) {
				[weakSelf.walletViewController reloadHistorySource];
			}
		} andPage:index];        
	});
}

- (void)reloadHistory {

	__weak __typeof (self) weakSelf = self;
	dispatch_async (_requestQueue, ^{
        
        [SLocator.contractHistoryFacadeService cancelOperations];
        
        if (weakSelf.isFailedConnection) {
            [weakSelf.tokenDetailsViewController conndectionFailed];
        }
        
		[weakSelf.walletViewController startLoadingIfNeeded];
		weakSelf.isHistoryLoaded = NO;
        
		[weakSelf.wallet updateHistoryWithHandler:^(BOOL success) {
			weakSelf.isHistoryLoaded = YES;
			if (success) {
				[weakSelf.walletViewController reloadHistorySource];
            } else {
                [weakSelf.walletViewController conndectionFailed];
            }
            [weakSelf.walletViewController stopLoading];
		} andPage:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateControls];
        });
	});
}

- (void)refreshContractHistoryOfToken:(Contract *) token withPage:(NSInteger) page {
    
    __weak __typeof (self) weakSelf = self;
    
    dispatch_async (_requestQueue, ^{
        
        [token updateHistoryWithHandler:^(BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.walletViewController reloadHistorySource];
                [SLocator.popupService dismissLoader];
            });
            
        } andPage:0];
        
    });
}

- (void)reloadContractHistoryOfToken:(Contract *) token {
    
    __weak __typeof (self) weakSelf = self;
    __block BOOL infoUpdated = NO;
    __block BOOL historyUpdated = NO;
    
    dispatch_async (_requestQueue, ^{
        
        [SLocator.historyFacadeService cancelOperations];
        
        if (weakSelf.isFailedConnection) {
            [weakSelf.walletViewController conndectionFailed];
        }
        
        [SLocator.popupService showLoaderPopUp];
        
        [token updateWithHandler:^(BOOL success) {
            infoUpdated = YES;
            
            if (historyUpdated && infoUpdated) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tokenDetailsViewController reloadHistorySource];
                    [SLocator.popupService dismissLoader];
                });
            }
        }];
        
        [token updateHistoryWithHandler:^(BOOL success) {
            
            historyUpdated = YES;
            
            if (historyUpdated && infoUpdated) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tokenDetailsViewController reloadHistorySource];
                    [SLocator.popupService dismissLoader];
                });
            }
            
        } andPage:0];
    });
}

-(void)updateTokensList {
    
    if (self.tokenController) {
        self.tokenController.tokens = [SLocator.contractManager allActiveTokens];
        [self.tokenController reloadTable];
    }
}

- (void)stopRefreshing {

	if (self.isBalanceLoaded && self.isHistoryLoaded) {
		[self.walletViewController stopLoading];
	}
}

- (void)subcribeEvents {

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updateSpendables) name:kWalletDidChange object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (fireHistoryElementTimerUpdate) name:kWalletHistoryDidChange object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (updateTokens) name:kTokenDidChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (didConnectToSocket) name:kSocketDidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (didDisconnectFromSocket) name:kSocketDidDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (didDisconnectFromSocket) name:kSocketConnectionFailed object:nil];
}

- (void)fireHistoryElementTimerUpdate {

	__weak __typeof (self) weakSelf = self;
	dispatch_async (dispatch_get_main_queue (), ^{
        
        weakSelf.firesTimerCount = 0;
        
        if (weakSelf.historyElementsTimerUpdate) {
            [weakSelf.historyElementsTimerUpdate invalidate];
            weakSelf.historyElementsTimerUpdate = nil;
        }

		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector (updatingTimerFire) userInfo:nil repeats:YES];
		weakSelf.historyElementsTimerUpdate = timer;
	});
}

- (void)updatingTimerFire {

	[self checkTimerStateAndReplaceTimerIfNeeded];
	[self sendUpdatingHistoryTimeNotification];
}

- (void)checkTimerStateAndReplaceTimerIfNeeded {

	if (self.firesTimerCount > 60 && self.historyElementsTimerUpdate.timeInterval < 60) {

		[self.historyElementsTimerUpdate invalidate];
		self.historyElementsTimerUpdate = nil;

		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector (updatingTimerFire) userInfo:nil repeats:YES];
		self.historyElementsTimerUpdate = timer;
	}
}

- (void)sendUpdatingHistoryTimeNotification {

	self.firesTimerCount++;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Time" object:nil];
}

- (void)updateSpendableHistory {
	[self updateSpendables];
}

- (void)updateSpendables {

	NSArray *tokensArray = [SLocator.contractManager allActiveTokens];
	self.delegateDataSource.haveTokens = tokensArray.count > 0;
	self.tokenController.tokens = tokensArray;
	[self.tokenController reloadTable];

	__weak __typeof (self) weakSelf = self;

	if (tokensArray.count == 0) {
		dispatch_async (dispatch_get_main_queue (), ^{
			[weakSelf.pageViewController scrollToRootIfNeededAnimated:YES];
		});
	} else {
		dispatch_async (dispatch_get_main_queue (), ^{
			[weakSelf.pageViewController setScrollingToTokensAvailableIfNeeded];
		});
	}
}

- (void)updateTokens {

	[self configWallet];
	[self setWalletToDelegates];
	[self updateTokenDetail];
    
	__weak __typeof (self) weakSelf = self;

	dispatch_async (dispatch_get_main_queue (), ^{

		[weakSelf updateSpendables];
        [weakSelf updateControls];
	});
}

- (void)updateControls {

	NSArray *tokensArray = [SLocator.contractManager allActiveTokens];
	[self.pageViewController setPageControllHidden:!tokensArray.count];
}

- (void)updateTokenDetail {

	[self.tokenDetailsViewController reloadTokenInfo];
}

- (void)showAddressControlFlow {

	AddressLibruaryCoordinator *coordinator = [[AddressLibruaryCoordinator alloc] initWithNavigationViewController:self.navigationController];
	[coordinator start];
	coordinator.delegate = self;
	[self addDependency:coordinator];
}

- (void)showTokenAddressControlFlowWith:(Contract *) contract {

	TokenAddressLibraryCoordinator *coordinator = [[TokenAddressLibraryCoordinator alloc] initWithNavigationViewController:self.navigationController];
	coordinator.token = contract;
	coordinator.delegate = self;
	[coordinator start];
	[self addDependency:coordinator];
}

- (void)didConnectToSocket {
    self.isFailedConnection = NO;
    [self.walletViewController conndectionSuccess];
}

- (void)didDisconnectFromSocket {
    self.isFailedConnection = YES;
    [self.walletViewController conndectionFailed];
}

#pragma mark - AddressLibruaryCoordinator, TokenAddressLibraryCoordinatorDelegate

- (void)coordinatorLibraryDidEnd:(BaseCoordinator *) coordinator {
	[self removeDependency:coordinator];
}

- (void)coordinatorLibraryDidEnd:(AddressLibruaryCoordinator *) coordinator withQrCodeItem:(SendInfoItem *) item {

	[self.delegate createPaymentFromSendInfoItem:item];
	[self removeDependency:coordinator];
}

#pragma mark - ShareTokenPopupViewControllerDelegate and PopUpViewControllerDelegate

- (void)copyAddressButtonPressed:(PopUpViewController *) sender {

	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
	[self copyTextAndShowPopUp:self.tokenDetailsViewController.token.contractAddress isAbi:NO];
}

- (void)copyAbiButtonPressed:(PopUpViewController *) sender {

	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
	[self copyTextAndShowPopUp:[SLocator.contractFileManager escapeAbiWithTemplate:self.tokenDetailsViewController.token.templateModel.path] isAbi:YES];
}

- (void)copyTextAndShowPopUp:(NSString *) text isAbi:(BOOL) isAbi {

	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	NSString *keyString = text;
	[pb setString:keyString];

	PopUpContent *content = isAbi ? [PopUpContentGenerator contentForAbiCopied] : [PopUpContentGenerator contentForAddressCopied];
	[SLocator.popupService showInformationPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)okButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

#pragma mark - HistoryItemOutputDelegate

- (void)didPressedCopyWithValue:(NSString*) value {
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString *keyString = value ?: @"";
    [pb setString:keyString];
    
    PopUpContent *content = [PopUpContentGenerator contentForCopied];
    [SLocator.popupService showInformationPopUp:self withContent:content presenter:nil completion:nil];
}


#pragma mark - RecieveOutputDelegate

- (void)didPressedChooseAddressWithPreviusAddress:(NSString *) prevAddress {

	NSObject <ChooseReciveAddressOutput> *output = [SLocator.controllersFactory createChooseReciveAddressOutput];
	output.delegate = self;
	output.prevAddress = prevAddress;
	output.addresses = SLocator.walletManager.wallet.allKeysAdreeses;
	[self.navigationController pushViewController:[output toPresent] animated:YES];
}

- (void)didChooseAddress:(NSString *) address {

	[self.navigationController popViewControllerAnimated:YES];

	self.reciveOutput.walletAddress = address;
	SLocator.walletManager.wallet.mainAddress = address;
	[self.reciveOutput updateControls];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)cancelButtonPressed:(PopUpViewController *) sender {
    [SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

#pragma mark - WalletOutputDelegate

- (void)didShowQRCodeScan {

	NSObject <QRCodeOutput> *output = [SLocator.controllersFactory createQRCodeViewControllerForWallet];
	output.delegate = self;
	[self.navigationController pushViewController:[output toPresent] animated:YES];
}

- (void)didReloadTableViewData {

	[self updateControls];

	if (self.isNewDataLoaded) {
        self.isBalanceLoaded = YES;
		[self reloadHistory];
	}
}

- (void)didShowAddressControl {

	[self showAddressControlFlow];
}


@end
