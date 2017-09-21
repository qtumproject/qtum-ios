//
//  AddressLibruaryCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressLibruaryCoordinator.h"
#import "AddressControlOutput.h"
#import "Wallet.h"
#import "AddressTransferPopupViewController.h"
#import "TransactionManager.h"
#import "ErrorPopUpViewController.h"
#import "NSNumber+Comparison.h"

@interface AddressLibruaryCoordinator () <AddressControlOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject <AddressControlOutput> *addressOutput;
@property (nonatomic, copy) NSDictionary <NSString*, BTCKey*> *addressKeyHashTable;
@property (nonatomic, copy) NSDictionary <NSString*, NSNumber*> *addressBalanceHashTable;

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
    self.addressOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    [self getAddresesData];
}

-(void)getAddresesData {
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getUnspentOutputsForAdreses:[[ApplicationCoordinator sharedInstance].walletManager.wallet allKeysAdreeses] isAdaptive:YES successHandler:^(id responseObject) {
        [weakSelf updateAddresesListWithResponse:responseObject];
        [[PopUpsManager sharedInstance] dismissLoader];

    } andFailureHandler:^(NSError *error, NSString *message) {
        
        [[PopUpsManager sharedInstance] dismissLoader];
    }];
}

-(NSDictionary*)prepareAddresesDataWithResponse:(NSArray*) response {
    
    NSMutableDictionary* addressAmountHashTable = @{}.mutableCopy;
    
    for (NSString* address in self.addressKeyHashTable.allKeys) {
        [addressAmountHashTable setObject:[[NSDecimalNumber alloc] initWithDouble:0.] forKey:address];
    }
    
    for (NSDictionary* item in response) {
        
        NSString* address = item[@"address"];
        NSNumber* amountNumber = item[@"amount"];
        double amountDouble = [amountNumber doubleValue];
        
        if (address && amountDouble > 0) {
            
            NSDecimalNumber* addressAmountDecimalConteiner = addressAmountHashTable[address];
            NSDecimalNumber* newBalance = [addressAmountDecimalConteiner decimalNumberByAdding:[amountNumber decimalNumber]];
            [addressAmountHashTable setObject:newBalance forKey:address];
        }
    }
    
    return [addressAmountHashTable copy];
}

-(void)updateAddresesListWithResponse:(NSArray*) response  {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSDictionary <NSString*, NSNumber*> *data = [weakSelf prepareAddresesDataWithResponse:response];
            weakSelf.addressOutput.addressesValueHashTable = data;
            weakSelf.addressBalanceHashTable = data;
            [weakSelf.addressOutput reloadData];
        });
    }
}

-(void)makeTransferFromAddress:(NSString*)from toAddress:(NSString*) to withAmount:(NSString* )amount {

    NSDecimalNumber *amountDecimalContainer = [NSDecimalNumber decimalNumberWithString:amount];
    
//    NSArray *array = @[@{@"amount" : amountDecimalContainer, @"address" : to}];
    
    SendInfoItem *item = [[SendInfoItem alloc] initWithQtumAddressKey:self.addressKeyHashTable[to] tokenAddress:nil amountString:amount fromQtumAddressKey:self.addressKeyHashTable[from]];

    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate coordinatorLibraryDidEnd:self withQrCodeItem:item];
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
    
    ErrorPopUpViewController *popUp = [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
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

-(void)didPressCellAtIndexPath:(NSIndexPath*) indexPath withAddress:(NSString *)address{
    
    [[PopUpsManager sharedInstance] showAddressTransferPopupViewController:self presenter:nil toAddress:address withFromAddressVariants:self.addressBalanceHashTable completion:^{
    }];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)okButtonPressed:(AddressTransferPopupViewController *)sender {
    
    if ([sender isKindOfClass:[AddressTransferPopupViewController class]]) {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
        [self makeTransferFromAddress:sender.fromAddress toAddress:sender.toAddress withAmount:[sender.amount stringByReplacingOccurrencesOfString:@"," withString:@"."]];
    } else {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    }
}

@end
