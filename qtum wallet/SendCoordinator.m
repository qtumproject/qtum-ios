//
//  SendCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SendCoordinator.h"
#import "NewPaymentViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "TransactionManager.h"

@interface SendCoordinator () <NewPaymentViewControllerDelegate, QRCodeViewControllerDelegate, ChoseTokenPaymentViewControllerDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) NewPaymentViewController* paymentViewController;
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

-(void)start {
    
    NewPaymentViewController* controller = (NewPaymentViewController*)[[ControllersFactory sharedInstance] createNewPaymentViewController];
    controller.delegate = self;
    self.paymentViewController = controller;
    [self.navigationController setViewControllers:@[controller]];
}

#pragma mark - Private Methods

-(void)payWithWalletWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    [self showLoaderPopUp];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[WalletManager sharedInstance].сurrentWallet allKeys] toAddressAndAmount:array andHandler:^(NSError *error, id response) {
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

#pragma mark - Popup

-(void)showErrorPopUp {
    [self.paymentViewController showErrorPopUp];
}

-(void)showCompletedPopUp {
    [self.paymentViewController showCompletedPopUp];
}

-(void)showLoaderPopUp {
    [self.paymentViewController showLoaderPopUp];
}

#pragma mark - NewPaymentViewControllerDelegate

- (void)showQRCodeScaner {
    
    QRCodeViewController* controller = (QRCodeViewController*)[[ControllersFactory sharedInstance] createQRCodeViewControllerForSend];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)showChooseToken {
    
    ChoseTokenPaymentViewController* tokenController = (ChoseTokenPaymentViewController*)[[ControllersFactory sharedInstance] createChoseTokenPaymentViewController];
    tokenController.delegate = self;
    tokenController.activeToken = self.token;
    [self.navigationController pushViewController:tokenController animated:YES];
}

- (void)didPressedSendActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount {
    
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

- (void)qrCodeScanned:(NSDictionary *)dictionary {
    
    [self.paymentViewController updateContentFromQRCode:dictionary];
}

- (void)showNextVC {
    
}

- (void)backButtonPressed {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ChoseTokenPaymentViewControllerDelegate

- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item {
    
    self.token = item;
    [self.navigationController popViewControllerAnimated:YES];
    [self.paymentViewController updateContentWithContract:item];
}

- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item{
    
}

- (void)resetToDefaults {
    
    [self.paymentViewController updateContentWithContract:nil];
    self.token = nil;
}



@end
