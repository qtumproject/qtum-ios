//
//  SendCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SendCoordinator.h"
#import "NewPaymentDarkViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "ChooseTokekPaymentDelegateDataSourceDelegate.h"
#import "NewPaymentOutputEntity.h"
#import "SendModuleRouter.h"
#import "ErrorPopUpViewController.h"
#import "ConfirmPopUpViewController.h"
#import "WalletManager.h"

@interface SendCoordinator () <NewPaymentOutputDelegate, QRCodeOutputDelegate, ChoseTokenPaymentOutputDelegate, ChooseTokekPaymentDelegateDataSourceDelegate, PopUpWithTwoButtonsViewControllerDelegate>

//oututs
@property (weak, nonatomic) NSObject <NewPaymentOutput> *paymentOutput;
@property (weak, nonatomic) NSObject <QRCodeOutput> *qrCodeOutput;
@property (weak, nonatomic) NSObject <ChoseTokenPaymentOutput> *tokenPaymentOutput;

@property (strong, nonatomic) Contract *token;
@property (assign, nonatomic) BOOL hasTokens;
@property (strong, nonatomic) ContracBalancesObject *choosenTokenAddressModal;

@property (strong, nonatomic) NSString *fromAddressString;
@property (strong, nonatomic) BTCKey *fromAddressKey;
@property (strong, nonatomic) NSOperationQueue *workingQueue;
@property (strong, nonatomic) dispatch_semaphore_t updatingSemaphore;
@property (assign, nonatomic) BOOL needProtectInputs;
@property (strong, nonatomic) id <BaseRouterProtocol> router;

@property (nonatomic, copy) void (^afterCheckingChangesBlock)(void);


@end

@implementation SendCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController {

	self = [super init];
	if (self) {
        
        _workingQueue = [NSOperationQueue new];
        _workingQueue.maxConcurrentOperationCount = 1;
        _updatingSemaphore = dispatch_semaphore_create (0);
        _router = [[BaseRouter alloc] initWithNavigationController:navigationController];
	}
	return self;
}

- (void)dealloc {
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Accessors

-(void)setToken:(Contract *)token {
    
    if (!token) {
        self.choosenTokenAddressModal = nil;
    }
    _token = token;
}

#pragma mark - Coordinator

- (void)start {

	NSObject <NewPaymentOutput> *output = [SLocator.controllersFactory createNewPaymentDarkViewController];
	output.delegate = self;
	self.paymentOutput = output;
    
	[self.router setRootOutput:output];

	[self showLoaderPopUp];

	__weak __typeof (self) weakSelf = self;
	[SLocator.transactionManager getFeePerKbWithHandler:^(QTUMBigNumber *feePerKb) {

		QTUMBigNumber *minFee = [feePerKb roundedNumberWithScale:5];
		QTUMBigNumber *maxFee = SLocator.paymentValuesManager.maxFee;

		[weakSelf.paymentOutput setMinFee:minFee andMaxFee:maxFee];
		[weakSelf.paymentOutput setMinGasPrice:SLocator.paymentValuesManager.minGasPrice andMax:SLocator.paymentValuesManager.maxGasPrice step:GasPriceStep];
		[weakSelf.paymentOutput setMinGasLimit:SLocator.paymentValuesManager.minGasLimit andMax:SLocator.paymentValuesManager.maxGasLimit standart:SLocator.paymentValuesManager.standartGasLimit step:GasLimitStep];
		[weakSelf hideLoaderPopUp];
	}];

    [self subscribeToEvents];
    
    [self pauseOperations];
}

- (void)pauseOperations {
    
    __weak __typeof(self)weakSelf = self;
    [self.workingQueue addOperationWithBlock:^{
        
        dispatch_semaphore_wait (weakSelf.updatingSemaphore, DISPATCH_TIME_FOREVER);
    }];
}

-(void)reusemeUpdatingOperations {
    
    dispatch_semaphore_signal(self.updatingSemaphore);
}

-(void)subscribeToEvents {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (tokensDidChange) name:kTokenDidChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (walletDidChange) name:kWalletDidChange object:nil];
}

- (void)setForSendSendInfoItem:(SendInfoItem *) item {
    
    self.needProtectInputs = YES;
    
	switch (item.type) {
		case SendInfoItemTypeQtum:
			self.token = nil;
			break;
		case SendInfoItemTypeInvalid:
			[SLocator.popupService showErrorPopUp:self withContent:[PopUpContentGenerator contentForInvalidQRCodeFormatPopUp] presenter:nil completion:nil];
			item = nil;
			self.token = nil;
			break;
		case SendInfoItemTypeToken: {
            
			NSArray <Contract *> *tokens = SLocator.contractManager.allActiveTokens;

			BOOL exist = NO;
			for (Contract *token in tokens) {
				if ([token.contractAddress isEqualToString:item.tokenAddress]) {
					self.token = token;
					exist = YES;
					break;
				}
			}

			if (!exist) {
				[SLocator.popupService showErrorPopUp:self withContent:[PopUpContentGenerator contentForRequestTokenPopUp] presenter:nil completion:nil];
				self.token = nil;
				item = nil;
			}
			break;
		}
	}

	self.fromAddressKey = item.fromQtumAddressKey;
    
    if (item.fromQtumAddress) {
        self.fromAddressString = item.fromQtumAddress;
        NSArray* tokenBalanceInfo = [SLocator.contractInfoFacade arrayOfStingValuesOfTokenBalanceWithToken:self.token];
        for (ContracBalancesObject* info in tokenBalanceInfo) {
            if ([info.addressString isEqualToString:item.fromQtumAddress]) {
                self.choosenTokenAddressModal = info;
                break;
            }
        }
    }    
    
	//bail if we have open 2 qrcode scaners
	if (self.qrCodeOutput) {
		[self.router popOutputAnimated:YES];
	}
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        [weakSelf checkTokens];
        NewPaymentOutputEntity* entity = [weakSelf entityWithSendInfo:item];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)setForToken:(Contract *) aToken withAddress:(NSString *) address andAmount:(NSString *) amount {

	SendInfoItem *item = [[SendInfoItem alloc] initWithQtumAddress:address tokenAddress:aToken.contractAddress amountString:amount];
	[self setForSendSendInfoItem:item];
}

- (void)didSelectedFromTabbar {}

#pragma mark - Observing

- (void)tokensDidChange {

    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NewPaymentOutputEntity* entity = [weakSelf entityWithToken];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)walletDidChange {
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NewPaymentOutputEntity* entity = [weakSelf defaultEntity];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
}

#pragma mark - Private Methods

-(NewPaymentOutputEntity*)entityWithSendInfo:(SendInfoItem*) item {
    
    NewPaymentOutputEntity* entity = [self entityWithToken];
    
    if (!item) {
        return entity;
    }
    
    entity.receiverAddress = item.qtumAddressKey ? [SLocator.walletManager stringAddressFromBTCKey:item.qtumAddressKey] : item.qtumAddress;
    entity.amount = item.amountString;
    
    return entity;
}

-(NewPaymentOutputEntity*)defaultEntity {
    
    NewPaymentOutputEntity* entity = [NewPaymentOutputEntity new];
    
    BOOL tokenExists = self.token ? YES : NO;
    
    entity.walletBalance = SLocator.walletManager.wallet.balance;
    entity.unconfirmedWalletBalance = SLocator.walletManager.wallet.unconfirmedBalance;
    entity.tokensExists = self.hasTokens;
    entity.tokenChoosen = tokenExists;
    
    return entity;
}

- (void)checkTokens {
    
    NSArray <Contract *> *tokens = SLocator.contractManager.allActiveTokens;

    if (![tokens containsObject:self.token]) {
        self.token = nil;
    }
    
    self.hasTokens = tokens.count > 0 ? YES : NO;
}

- (NewPaymentOutputEntity*)entityWithToken {
    
    NewPaymentOutputEntity* entity = [self defaultEntity];
    entity.tokenName = self.token.localName ?: @"";
    entity.tokenSymbol = self.token.symbol;
    
    entity.tokenBalancesInfo = [SLocator.contractInfoFacade sortedArrayOfStingValuesOfTokenBalanceWithToken:self.token];
    entity.contractBalanceString = self.token ? self.token.balanceString : @"";
    entity.shortContractBalanceString = self.token ? self.token.shortBalanceString : @"";
    
    if (!self.choosenTokenAddressModal) {
        self.choosenTokenAddressModal = self.token ? entity.tokenBalancesInfo[0] : nil;
    }
    entity.choosenTokenBalance = self.choosenTokenAddressModal;
    
    return entity;
}

- (void)updateOutputsWithEntity:(NewPaymentOutputEntity*) entity {

	__weak __typeof (self) weakSelf = self;
    
	dispatch_async (dispatch_get_main_queue (), ^{


		if (weakSelf.tokenPaymentOutput) {
			[weakSelf.tokenPaymentOutput updateWithTokens:SLocator.contractManager.allActiveTokens];
		}

		[weakSelf.paymentOutput updateWithEtity:entity];
	});
}

- (void)payWithWalletWithAddress:(NSString *) address andAmount:(QTUMBigNumber *) amount andFee:(QTUMBigNumber *) fee {

	if (![self isValidAmount:amount]) {
		return;
	}

	NSArray *array = @[@{@"amount": amount, @"address": address}];

	[self showLoaderPopUp];

	__weak typeof (self) weakSelf = self;
	NSArray<BTCKey *> *addresses = self.fromAddressKey ? @[self.fromAddressKey] : [SLocator.walletManager.wallet allKeys];
	[SLocator.transactionManager sendTransactionWalletKeys:addresses
										toAddressAndAmount:array
													   fee:fee
												andHandler:^(TransactionManagerErrorType errorType,
														id response,
														QTUMBigNumber *estimateFee) {

													[weakSelf hideLoaderPopUp];
													if (errorType == TransactionManagerErrorTypeNotEnoughFee) {
														[self showNotEnoughFeeAlertWithEstimatedFee:estimateFee];
													} else if (errorType == TransactionManagerErrorTypeNotEnoughGasLimit) {
														[weakSelf showStatusOfPayment:errorType withEstimateGasLimit:estimateFee];
													} else {
														[weakSelf showStatusOfPayment:errorType];
													}
												}];
}

- (void)payWithTokenWithAddress:(NSString *) address andAmount:(QTUMBigNumber *) amount fee:(QTUMBigNumber *) fee gasPrice:(QTUMBigNumber *) gasPrice gasLimit:(QTUMBigNumber *) gasLimit {

	QTUMBigNumber *amounDivByDecimals = [amount numberWithPowerOf10:self.token.decimals];

	if (![self isValidAmount:amounDivByDecimals]) {
		return;
	}

	[self showLoaderPopUp];
	__weak typeof (self) weakSelf = self;

	if (self.choosenTokenAddressModal) {
		[SLocator.transactionManager sendToken:self.token
								   fromAddress:self.choosenTokenAddressModal.addressString
									 toAddress:address
										amount:amounDivByDecimals
										   fee:fee
									  gasPrice:gasPrice
									  gasLimit:gasLimit
									andHandler:^(TransactionManagerErrorType errorType,
											BTCTransaction *transaction,
											NSString *hashTransaction,
											QTUMBigNumber *estimatedFee) {

										[weakSelf hideLoaderPopUp];
										if (errorType == TransactionManagerErrorTypeNotEnoughFee) {
											[weakSelf showNotEnoughFeeAlertWithEstimatedFee:estimatedFee];
										} else {
											[weakSelf showStatusOfPayment:errorType];
										}
									}];
	} else {
		[SLocator.transactionManager sendTransactionToToken:self.token
												  toAddress:address
													 amount:amounDivByDecimals
														fee:fee
												   gasPrice:gasPrice
												   gasLimit:gasLimit
												 andHandler:^(TransactionManagerErrorType errorType,
														 BTCTransaction *transaction, NSString *hashTransaction,
														 QTUMBigNumber *estimateFee) {

													 [weakSelf hideLoaderPopUp];
													 if (errorType == TransactionManagerErrorTypeNotEnoughFee) {
														 [weakSelf showNotEnoughFeeAlertWithEstimatedFee:estimateFee];
													 } else {
														 [weakSelf showStatusOfPayment:errorType];
													 }
												 }];
	}
}

- (void)showStatusOfPayment:(TransactionManagerErrorType) errorType {

	switch (errorType) {
		case TransactionManagerErrorTypeNone:
			[self showCompletedPopUp];
			break;
		case TransactionManagerErrorTypeNoInternetConnection:
			break;
		case TransactionManagerErrorTypeNotEnoughMoney:
			[self showErrorPopUp:NSLocalizedString(@"You have insufficient funds for this transaction", nil)];
			break;
		case TransactionManagerErrorTypeInvalidAddress:
			[self showErrorPopUp:NSLocalizedString(@"Invalid QTUM Address", nil)];
			break;
		case TransactionManagerErrorTypeNotEnoughMoneyOnAddress:
			[self showErrorPopUp:NSLocalizedString(@"You have insufficient funds for this transaction at this address", nil)];
			break;
		default:
			[self showErrorPopUp:nil];
			break;
	}
}

- (void)showNotEnoughFeeAlertWithEstimatedFee:(QTUMBigNumber *) estimatedFee {

	NSString *errorString = [NSString stringWithFormat:@"Insufficient fee. Please use minimum of %@ QTUM", estimatedFee.stringValue];
	[self showErrorPopUp:NSLocalizedString(errorString, nil)];
}

- (void)showStatusOfPayment:(TransactionManagerErrorType) errorType withEstimateGasLimit:(QTUMBigNumber *) gasLimit {

	NSString *errorString = [NSString stringWithFormat:@"Insufficient gas limit. Please use minimum of %@ QTUM", gasLimit.stringValue];
	[self showErrorPopUp:NSLocalizedString(errorString, nil)];
}

- (BOOL)isValidAmount:(QTUMBigNumber *) amount {

	if (![amount isGreaterThanInt:0]) {
		[self showErrorPopUp:NSLocalizedString(@"Transaction amount can't be zero. Please edit your transaction and try again", nil)];
		return NO;
	}

	return YES;
}

- (void)showChooseTokenOutput {
    
    NSObject <ChoseTokenPaymentOutput> *output = (NSObject <ChoseTokenPaymentOutput> *)[SLocator.controllersFactory createChoseTokenPaymentViewController];
    output.delegate = self;
    output.delegateDataSource = [SLocator.tableSourcesFactory createSendTokenPaymentSource];
    output.delegateDataSource.activeToken = self.token;
    output.delegateDataSource.delegate = self;
    [output updateWithTokens:SLocator.contractManager.allActiveTokens];
    self.tokenPaymentOutput = output;
    [self.router pushOutput:output animated:YES];
}

#pragma mark - Popup

- (void)showLoaderPopUp {
    
    [SLocator.popupService showLoaderPopUp];
}

- (void)showCompletedPopUp {
    
    [SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *) message {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (message) {
        content.messageString = message;
        content.titleString = NSLocalizedString(@"Failed", nil);
    }

    ErrorPopUpViewController *popUp = [SLocator.popupService showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
}

- (void)hideLoaderPopUp {
    [SLocator.popupService dismissLoader];
}

- (void)showConfirmChangesPopUp {
    
    PopUpContent *content = [PopUpContentGenerator contentForConfirmChangesInSend];
    [SLocator.popupService showConfirmPopUp:self withContent:content presenter:nil completion:nil];
}

#pragma mark - NewPaymentViewControllerDelegate

- (void)didSelectTokenAddress:(ContracBalancesObject*) tokenAddress {
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        weakSelf.choosenTokenAddressModal = tokenAddress;
        [weakSelf checkTokens];
        NewPaymentOutputEntity* entity = [weakSelf entityWithToken];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)didViewLoad {

    [self reusemeUpdatingOperations];
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        [weakSelf checkTokens];
        NewPaymentOutputEntity* entity = [weakSelf defaultEntity];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];

}

- (void)didPresseQRCodeScaner {

	NSObject <QRCodeOutput> *output = [SLocator.controllersFactory createQRCodeViewControllerForSend];
	output.delegate = self;
	self.qrCodeOutput = output;
	[self.router pushOutput:output animated:YES];
}

- (void)didPresseChooseToken {
    
    __weak typeof(self)weakSelf = self;
    
    if ([self isInputsProtected]) {
        [self showConfirmChangesPopUp];
        
        self.afterCheckingChangesBlock = ^{
            
            weakSelf.needProtectInputs = NO;
            [weakSelf showChooseTokenOutput];
        };
        
    } else {
        
        [self showChooseTokenOutput];
    }
}

- (void)didPresseSendActionWithAddress:(NSString *) address andAmount:(QTUMBigNumber *) amount fee:(QTUMBigNumber *) fee gasPrice:(QTUMBigNumber *) gasPrice gasLimit:(QTUMBigNumber *) gasLimit {

    if (![SLocator.validationInputService isValidAddressString:address]) {
        NSString *text = NSLocalizedString(@"Incorrect address", @"");
        [self showErrorPopUp:text];
        return;
    }
    
	__weak __typeof (self) weakSelf = self;
	[[ApplicationCoordinator sharedInstance] startSecurityFlowWithType:SendVerification WithHandler:^(BOOL success) {
		if (success) {
			[weakSelf payActionWithAddress:address andAmount:amount fee:fee gasPrice:gasPrice gasLimit:gasLimit];
		}
	}];
}

- (void)payActionWithAddress:(NSString *) address andAmount:(QTUMBigNumber *) amount fee:(QTUMBigNumber *) fee gasPrice:(QTUMBigNumber *) gasPrice gasLimit:(QTUMBigNumber *) gasLimit {

	if (self.token) {
		[self payWithTokenWithAddress:address andAmount:amount fee:fee gasPrice:gasPrice gasLimit:gasLimit];
	} else {
		[self payWithWalletWithAddress:address andAmount:amount andFee:fee];
	}
}

- (BOOL)shoudStartEditingAddress {
    
    BOOL shoudStartEdite = ![self isInputsProtected];
    
    if (!shoudStartEdite) {
        
        __weak __typeof (self) weakSelf = self;

        [self showConfirmChangesPopUp];
        self.afterCheckingChangesBlock = ^{
            weakSelf.needProtectInputs = NO;
            [weakSelf.paymentOutput startEditingAddress];
        };
    }
    return shoudStartEdite;
}

- (BOOL)isInputsProtected {
    
    return (self.fromAddressKey != nil || self.fromAddressString != nil) && self.needProtectInputs;
}


- (void)changeToStandartOperation {
	self.fromAddressKey = nil;
	self.fromAddressString = nil;
}

#pragma mark - QRCodeOutputDelegate

- (void)didQRCodeScannedWithSendInfoItem:(SendInfoItem *) item {

	[self.router popOutputAnimated:YES];
	[self setForSendSendInfoItem:item];
}

- (void)didBackPressed {

    [self.router popOutputAnimated:YES];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *) sender {
    
    if ([sender isKindOfClass:[ConfirmPopUpViewController class]]) {
        
        if (self.afterCheckingChangesBlock) {
            self.afterCheckingChangesBlock();
            self.afterCheckingChangesBlock = nil;
        }
    }
    
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *) sender {
    
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

#pragma mark - ChoseTokenPaymentViewControllerDelegate

- (void)didPressedBackAction {

    [self.router popOutputAnimated:YES];
}

#pragma mark - ChoseTokenPaymentOutputDelegate

- (void)didSelectTokenIndexPath:(NSIndexPath *) indexPath withItem:(Contract *) item {
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        weakSelf.token = item;
        weakSelf.choosenTokenAddressModal = nil;
        [weakSelf checkTokens];
        NewPaymentOutputEntity* entity = [weakSelf entityWithToken];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
    [self.router popOutputAnimated:YES];
}

- (void)didResetToDefaults {

    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        weakSelf.token = nil;
        [weakSelf checkTokens];
        NewPaymentOutputEntity* entity = [weakSelf entityWithToken];
        [weakSelf updateOutputsWithEntity:entity];
    }];
    
    [self.workingQueue addOperation:operation];
}

@end
