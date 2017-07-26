//
//  SendCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SendCoordinator.h"
#import "NewPaymentDarkViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "TransactionManager.h"
#import "NewPaymentOutput.h"
#import "ChoseTokenPaymentOutput.h"
#import "ChooseTokenPaymentDelegateDataSourceProtocol.h"
#import "ChooseTokekPaymentDelegateDataSourceDelegate.h"
#import "WalletManagerRequestAdapter.h"
#import "Wallet.h"

@interface SendCoordinator () <NewPaymentOutputDelegate, QRCodeViewControllerDelegate, ChoseTokenPaymentOutputDelegate, ChooseTokekPaymentDelegateDataSourceDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) NSObject <NewPaymentOutput>* paymentOutput;
@property (weak, nonatomic) NSObject <ChoseTokenPaymentOutput>* tokenPaymentOutput;
@property (strong,nonatomic) Contract* token;

@end

@implementation SendCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController {
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)start {
    
    id <NewPaymentOutput> controller = [[ControllersFactory sharedInstance] createNewPaymentDarkViewController];
    controller.delegate = self;
    self.paymentOutput = controller;
    [self.navigationController setViewControllers:@[controller]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokensDidChange) name:kTokenDidChange object:nil];
}

- (void)setForSendQRCodeItem:(QRCodeItem *)item {
    
    switch (item.type) {
        case QRCodeItemTypeQtum:
            self.token = nil;
            break;
        case QRCodeItemTypeInvalid:
            [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator contentForInvalidQRCodeFormatPopUp] presenter:nil completion:nil];
            item = nil;
            self.token = nil;
            break;
        case QRCodeItemTypeToken:
        {
            NSArray <Contract*>* tokens = [ContractManager sharedInstance].allActiveTokens;
            
            BOOL exist = NO;
            for (Contract *token in tokens) {
                if ([token.mainAddress isEqualToString:item.tokenAddress]) {
                    self.token = token;
                    exist = YES;
                    break;
                }
            }
            
            if (!exist) {
                [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator contentForRequestTokenPopUp] presenter:nil completion:nil];
                [self.paymentOutput setQRCodeItem:nil];
                self.token = nil;
                item = nil;
            }
            break;
        }
    }
    
    [self.paymentOutput updateContentWithContract:self.token];
    [self.paymentOutput setQRCodeItem:item];
    [self updateOutputs];
}

#pragma mark - Observing

-(void)tokensDidChange {
    
    [self updateOutputs];
}

#pragma mark - Private Methods

-(void)updateOutputs {
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSArray <Contract*>* tokens = [ContractManager sharedInstance].allActiveTokens;
        BOOL tokenExists = NO;
        
        if (weakSelf.tokenPaymentOutput) {
            [weakSelf.tokenPaymentOutput updateWithTokens:tokens];
        }
        
        if (self.token && [tokens containsObject:self.token]) {
            tokenExists = YES;
        } else {
            self.token = nil;
        }
        
        [weakSelf.paymentOutput updateControlsWithTokensExist:tokens.count choosenTokenExist:tokenExists walletBalance:[ApplicationCoordinator sharedInstance].walletManager.wallet.balance andUnconfimrmedBalance:[ApplicationCoordinator sharedInstance].walletManager.wallet.unconfirmedBalance];
    });
}

-(void)payWithWalletWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    if (![self isValidAmount:amount]) {
        return;
    }
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    [self showLoaderPopUp];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[ApplicationCoordinator sharedInstance].walletManager.wallet allKeys] toAddressAndAmount:array andHandler:^(TransactionManagerErrorType errorType, id response) {
        
        [weakSelf hideLoaderPopUp];
        [weakSelf showStatusOfPayment:errorType];
    }];
}

-(void)payWithTokenWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    if (![self isValidAmount:amount]) {
        return;
    }
    
    [self showLoaderPopUp];
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionToToken:self.token toAddress:address amount:amount andHandler:^(TransactionManagerErrorType errorType, BTCTransaction * transaction, NSString* hashTransaction) {
        
        [weakSelf hideLoaderPopUp];
        [weakSelf showStatusOfPayment:errorType];
    }];
}

- (void)showStatusOfPayment:(TransactionManagerErrorType)errorType {
    
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
        default:
            [self showErrorPopUp:nil];
            break;
    }
}

- (BOOL)isValidAmount:(NSNumber *)amount {
    
    if ([amount floatValue] <= 0.0f) {
        [self showErrorPopUp:NSLocalizedString(@"Transaction amount can't be zero. Please edit your transaction and try again", nil)];
        return NO;
    }
    
    return YES;
}

#pragma mark - Popup

-(void)hideLoaderPopUp {
    [self.paymentOutput hideLoaderPopUp];
}

-(void)showErrorPopUp:(NSString *)message {
    [self.paymentOutput showErrorPopUp:message];
}

-(void)showCompletedPopUp {
    [self.paymentOutput showCompletedPopUp];
}

-(void)showLoaderPopUp {
    [self.paymentOutput showLoaderPopUp];
}

#pragma mark - NewPaymentViewControllerDelegate

-(void)didViewLoad {
    
    [self updateOutputs];
}

- (void)didPresseQRCodeScaner {
    
    QRCodeViewController* controller = (QRCodeViewController*)[[ControllersFactory sharedInstance] createQRCodeViewControllerForSend];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didPresseChooseToken {
    
    NSObject <ChoseTokenPaymentOutput>* tokenController = (NSObject <ChoseTokenPaymentOutput>*)[[ControllersFactory sharedInstance] createChoseTokenPaymentViewController];
    tokenController.delegate = self;
    tokenController.delegateDataSource = [[TableSourcesFactory sharedInstance] createSendTokenPaymentSource];
    tokenController.delegateDataSource.activeToken = self.token;
    tokenController.delegateDataSource.delegate = self;
    [tokenController updateWithTokens:[ContractManager sharedInstance].allActiveTokens];
    self.tokenPaymentOutput = tokenController;
    [self.navigationController pushViewController:[tokenController toPresent] animated:YES];
}

- (void)didPresseSendActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    __weak __typeof (self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance] startSecurityFlowWithType:SendVerification WithHandler:^(BOOL success) {
        if (success) {
            [weakSelf payActionWithAddress:address andAmount:amount];
        }
    }];
}

- (void)payActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    if (self.token) {
        [self payWithTokenWithAddress:address andAmount:amount];
    } else {
        [self payWithWalletWithAddress:address andAmount:amount];
    }
}

#pragma mark - QRCodeViewControllerDelegate

- (void)didQRCodeScannedWithQRCodeItem:(QRCodeItem *)item {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [self setForSendQRCodeItem:item];
}

- (void)didBackPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    [self didPresseQRCodeScaner];
}

#pragma mark - ChoseTokenPaymentViewControllerDelegate

- (void)didPressedBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ChoseTokenPaymentOutputDelegate

- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item {
    
    self.token = item;
    [self.navigationController popViewControllerAnimated:YES];
    [self.paymentOutput updateContentWithContract:item];
}

- (void)didResetToDefaults {
    
    [self.paymentOutput updateContentWithContract:nil];
    self.token = nil;
}


 
@end
