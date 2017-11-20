//
//  AddressLibruaryCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AddressLibruaryCoordinator.h"
#import "AddressControlOutput.h"
#import "AddressTransferPopupViewController.h"
#import "ErrorPopUpViewController.h"

@interface AddressLibruaryCoordinator () <AddressControlOutputDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, weak) NSObject <AddressControlOutput> *addressOutput;
@property (nonatomic, copy) NSDictionary <NSString*, BTCKey*> *addressKeyHashTable;
@property (nonatomic, copy) NSArray <WalletBalancesObject*>* arrayWithAddressesAndBalances;

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
    
    NSObject <AddressControlOutput> *output = [SLocator.controllersFactory createAddressControllOutput];
    self.addressKeyHashTable = [SLocator.walletManager.wallet addressKeyHashTable];
    output.delegate = self;
    self.addressOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    [self getAddresesData];
}

-(void)getAddresesData {
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    __weak __typeof(self)weakSelf = self;
    [SLocator.requestManager getUnspentOutputsForAdreses:[SLocator.walletManager.wallet allKeysAdreeses] isAdaptive:YES successHandler:^(id responseObject) {
        [weakSelf updateAddresesListWithResponse:responseObject];
        [[PopUpsManager sharedInstance] dismissLoader];

    } andFailureHandler:^(NSError *error, NSString *message) {
        
        [[PopUpsManager sharedInstance] dismissLoader];
    }];
}

-(NSArray <WalletBalancesObject*>*)prepareAddresesDataWithResponse:(NSArray*) response {
    
    NSArray* allAddressesArray = [SLocator.walletManager.wallet addressesInRightOrder];
    NSMutableArray <WalletBalancesObject*>* resultArray = @[].mutableCopy;
    
    for (int i = 0; i < allAddressesArray.count; i++) {
        
        WalletBalancesObject* object = [WalletBalancesObject new];
        NSString* address = allAddressesArray[i];
        object.addressString = address;
        object.longBalanceStringBalance = [[QTUMBigNumber decimalWithInteger:0] stringValue];
        object.shortBalanceStringBalance = [[QTUMBigNumber decimalWithInteger:0] stringValue];
        [resultArray addObject:object];
    }
    
    for (NSDictionary* item in response) {
        
        NSString* address = item[@"address"];
        NSNumber* amountNumber = item[@"amount"];
        double amountDouble = [amountNumber doubleValue];
        QTUMBigNumber* bigAmount = [QTUMBigNumber decimalWithString:amountNumber.stringValue];
        
        if (address && amountDouble > 0) {
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"addressString == %@",address];
            NSArray *filteredObjects = [resultArray filteredArrayUsingPredicate:predicate];
            
            if (filteredObjects.count == 0) {
                continue;
            }
            
            WalletBalancesObject* object = filteredObjects[0];

            QTUMBigNumber* addressAmountDecimalConteiner = [QTUMBigNumber decimalWithString:object.longBalanceStringBalance];
            QTUMBigNumber* newBalance = [addressAmountDecimalConteiner add:bigAmount];
            object.longBalanceStringBalance = [newBalance stringValue];
            object.shortBalanceStringBalance = [newBalance shortFormatOfNumber];
        }
    }
    
    return [resultArray copy];
}

-(void)updateAddresesListWithResponse:(NSArray*) response  {
    
    if ([response isKindOfClass:[NSArray class]]) {
        
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSArray <WalletBalancesObject*>* data = [weakSelf prepareAddresesDataWithResponse:response];
            weakSelf.addressOutput.arrayWithAddressesAndBalances = data;
            weakSelf.arrayWithAddressesAndBalances = data;
            [weakSelf.addressOutput reloadData];
        });
    }
}

-(void)makeTransferFromAddress:(NSString*)from toAddress:(NSString*) to withAmount:(NSString* )amount {
    
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
    
    [[PopUpsManager sharedInstance] showAddressTransferPopupViewController:self presenter:nil toAddress:address withFromAddressVariants:self.arrayWithAddressesAndBalances completion:nil];
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
