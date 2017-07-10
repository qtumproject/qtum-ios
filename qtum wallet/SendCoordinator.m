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

@interface SendCoordinator () <NewPaymentOutputDelegate, QRCodeViewControllerDelegate, ChoseTokenPaymentOutputDelegate, ChooseTokekPaymentDelegateDataSourceDelegate>

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

#pragma mark - Observing

-(void)tokensDidChange {
    
    if (self.tokenPaymentOutput) {
        [self.tokenPaymentOutput updateWithTokens:[ContractManager sharedInstance].allActiveTokens];
    }
    
    [self.paymentOutput updateControlsWithTokenExist:[ContractManager sharedInstance].allActiveTokens.count walletBalance:[WalletManager sharedInstance].currentWallet.balance andUnconfimrmedBalance:[WalletManager sharedInstance].currentWallet.unconfirmedBalance];
}

#pragma mark - Private Methods

-(void)payWithWalletWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    [self showLoaderPopUp];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[WalletManager sharedInstance].currentWallet allKeys] toAddressAndAmount:array andHandler:^(NSError *error, id response) {
        [[PopUpsManager sharedInstance] dismissLoader];
        if (!error) {
            [weakSelf showCompletedPopUp];
        }else{
            if ([error isNoInternetConnectionError]) {
                return;
            }
            [weakSelf showErrorPopUp];
        }
    }];
}

-(void)payWithTokenWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    [self showLoaderPopUp];
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionToToken:self.token toAddress:address amount:amount andHandler:^(NSError* error, BTCTransaction * transaction, NSString* hashTransaction) {
        
        [weakSelf hideLoaderPopUp];
        [weakSelf.paymentOutput clearFields];
        
        if (!error) {
            [weakSelf showCompletedPopUp];
        }else{
            if ([error isNoInternetConnectionError]) {
                return;
            }
            [weakSelf showErrorPopUp];
        }
    }];
}

#pragma mark - Popup

-(void)hideLoaderPopUp {
    [self.paymentOutput hideLoaderPopUp];
}

-(void)showErrorPopUp {
    [self.paymentOutput showErrorPopUp];
}

-(void)showCompletedPopUp {
    [self.paymentOutput showCompletedPopUp];
}

-(void)showLoaderPopUp {
    [self.paymentOutput showLoaderPopUp];
}

#pragma mark - NewPaymentViewControllerDelegate

-(void)didViewLoad {
    [self.paymentOutput updateControlsWithTokenExist:[ContractManager sharedInstance].allActiveTokens.count walletBalance:[WalletManager sharedInstance].currentWallet.balance andUnconfimrmedBalance:[WalletManager sharedInstance].currentWallet.unconfirmedBalance];
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
    [self.navigationController pushViewController:[tokenController toPresente] animated:YES];
}

- (void)didPresseSendActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    __weak __typeof (self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance] startSecurityFlowWithHandler:^(BOOL success) {
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

- (void)didQRCodeScannedWithDict:(NSDictionary*)dict {
    
    [self.paymentOutput updateContentFromQRCode:dict];
    [self.paymentOutput updateControlsWithTokenExist:[ContractManager sharedInstance].allActiveTokens.count walletBalance:[WalletManager sharedInstance].currentWallet.balance andUnconfimrmedBalance:[WalletManager sharedInstance].currentWallet.unconfirmedBalance];
}

- (void)didBackPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
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
