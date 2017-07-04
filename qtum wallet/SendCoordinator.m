//
//  SendCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SendCoordinator.h"
#import "NewPaymentDarkViewController.h"
#import "QRCodeViewController.h"
#import "ChoseTokenPaymentViewController.h"
#import "TransactionManager.h"
#import "NewPaymentOutput.h"
#import "ChoseTokenPaymentOutput.h"

@interface SendCoordinator () <NewPaymentOutputDelegate, QRCodeViewControllerDelegate, ChoseTokenPaymentOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) NSObject <NewPaymentOutput>* paymentOutput;
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
    
    id <NewPaymentOutput> controller = [[ControllersFactory sharedInstance] createNewPaymentDarkViewController];
    controller.delegate = self;
    self.paymentOutput = controller;
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
    [self.paymentOutput showErrorPopUp];
}

-(void)showCompletedPopUp {
    [self.paymentOutput showCompletedPopUp];
}

-(void)showLoaderPopUp {
    [self.paymentOutput showLoaderPopUp];
}

#pragma mark - NewPaymentViewControllerDelegate

- (void)showQRCodeScaner {
    
    QRCodeViewController* controller = (QRCodeViewController*)[[ControllersFactory sharedInstance] createQRCodeViewControllerForSend];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)showChooseToken {
    
    NSObject <ChoseTokenPaymentOutput>* tokenController = (NSObject <ChoseTokenPaymentOutput>*)[[ControllersFactory sharedInstance] createChoseTokenPaymentViewController];
    tokenController.delegate = self;
    tokenController.activeToken = self.token;
    [self.navigationController pushViewController:[tokenController toPresente] animated:YES];
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
    
    [self.paymentOutput updateContentFromQRCode:dictionary];
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
    [self.paymentOutput updateContentWithContract:item];
}

- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item{
    
}

- (void)resetToDefaults {
    
    [self.paymentOutput updateContentWithContract:nil];
    self.token = nil;
}



@end
