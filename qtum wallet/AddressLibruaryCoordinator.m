//
//  AddressLibruaryCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressLibruaryCoordinator.h"
#import "AddressControlOutput.h"
#import "Wallet.h"
#import "AddressTransferPopupViewController.h"
#import "TransactionManager.h"

@interface AddressLibruaryCoordinator () <AddressControlOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject <AddressControlOutput> *addressOutput;
@property (nonatomic, copy) NSDictionary <NSString*, BTCKey*> *addressKeyHashTable;

@end

@implementation AddressLibruaryCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController {
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

-(void)start {
    
    NSObject <AddressControlOutput> *output = [[ControllersFactory sharedInstance] createAddressControllOutput];
    self.addressKeyHashTable = [[ApplicationCoordinator sharedInstance].walletManager.wallet addressKeyHashTable];
    output.delegate = self;
    output.addresses = self.addressKeyHashTable.allKeys;
    self.addressOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    [self prepareData];
}

-(void)prepareData {
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    [[ApplicationCoordinator sharedInstance].requestManager getUnspentOutputsForAdreses:[[ApplicationCoordinator sharedInstance].walletManager.wallet allKeysAdreeses] isAdaptive:YES successHandler:^(id responseObject) {
        
        [[PopUpsManager sharedInstance] dismissLoader];

    } andFailureHandler:^(NSError *error, NSString *message) {
        
        [[PopUpsManager sharedInstance] dismissLoader];
    }];
}

-(void)makeTransferFromAddress:(NSString*)from toAddress:(NSString*) to withAmount:(NSString* )amount {
    
    NSDecimalNumber *amountDecimalContainer = [NSDecimalNumber decimalNumberWithString:amount];
    
    NSArray *array = @[@{@"amount" : amountDecimalContainer, @"address" : to}];
    
    [self showLoaderPopUp];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:@[self.addressKeyHashTable[from]] toAddressAndAmount:array andHandler:^(TransactionManagerErrorType errorType, id response) {
        
        [weakSelf hideLoaderPopUp];
        [weakSelf showStatusOfPayment:errorType];
    }];
}

#pragma mark - Popup

- (void)showLoaderPopUp {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
}

- (void)showCompletedPopUp {
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *)message {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (message) {
        content.messageString = message;
        content.titleString = NSLocalizedString(@"Failed", nil);
    }
    
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)hideLoaderPopUp {
    [[PopUpsManager sharedInstance] dismissLoader];
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


#pragma mark - AddressControlOutputDelegate

-(void)didBackPress {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate coordinatorLibraryDidEnd:self];
}

-(void)didPressCellAtIndexPath:(NSIndexPath*) indexPath {
    
    [[PopUpsManager sharedInstance] showAddressTransferPopupViewController:self presenter:nil toAddress:self.addressKeyHashTable.allKeys[indexPath.row] withFromAddressVariants:self.addressKeyHashTable.allKeys completion:^{
        
    }];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)okButtonPressed:(AddressTransferPopupViewController *)sender {
    
    if ([sender isKindOfClass:[AddressTransferPopupViewController class]]) {
            [self makeTransferFromAddress:sender.fromAddress toAddress:sender.toAddress withAmount:[sender.amount stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    } else {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    }
    
}

@end
