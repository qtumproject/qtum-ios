//
//  NewPaymentViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "NewPaymentViewController.h"
#import "TransactionManager.h"
#import "QRCodeViewController.h"
#import "TextFieldWithLine.h"
#import "TokenListViewController.h"
#import "ChoseTokenPaymentViewController.h"

@interface NewPaymentViewController () <UITextFieldDelegate, QRCodeViewControllerDelegate,ChoseTokenPaymentViewControllerDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;

@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenTextField;
@property (weak, nonatomic) IBOutlet UIButton *tokenButton;
@property (weak, nonatomic) IBOutlet UIImageView *tokenDisclousureImage;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withoutTokensConstraint;

@property (strong,nonatomic) NSString* adress;
@property (strong,nonatomic) NSString* amount;

@property (strong,nonatomic) Contract* token;
@property (nonatomic) BOOL needUpdateTexfFields;

- (IBAction)makePaymentButtonWasPressed:(id)sender;

@end

static NSInteger withTokenOffset = 80;
static NSInteger withoutTokenOffset = 30;

@implementation NewPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addDoneButtonToAmountTextField];
    
    if (self.dictionary) {
        [self qrCodeScanned:self.dictionary];
    }    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.needUpdateTexfFields) {
        self.addressTextField.text = self.adress;
        self.amountTextField.text = self.amount;
    }
    [self checkActiveToken];
    [self updateControls];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

-(void)checkActiveToken {
    
    if (![[ContractManager sharedInstance].getAllActiveTokens containsObject:self.token]) {
        self.token = nil;
    }
}

-(void)updateControls{
    
    self.residueValueLabel.text = [NSString stringWithFormat:@"%.3f",[WalletManager sharedInstance].getCurrentWallet.balance];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%.3f",[WalletManager sharedInstance].getCurrentWallet.unconfirmedBalance];
    
    BOOL isTokensExists = [ContractManager sharedInstance].getAllActiveTokens.count;
    self.tokenTextField.hidden =
    self.tokenButton.hidden =
    self.tokenDisclousureImage.hidden = !isTokensExists;
    self.withoutTokensConstraint.constant = isTokensExists ? withTokenOffset : withoutTokenOffset;
    self.tokenDisclousureImage.tintColor = customBlueColor();
    self.tokenTextField.text =  self.token ? self.token.localName : NSLocalizedString(@"QTUM (Default)", @"");
    
    [self.view layoutSubviews];
}

-(void)payWithWallet:(NSString *)amountString {
    
    NSNumber *amount = @([amountString doubleValue]);
    NSString *address = self.addressTextField.text;
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[WalletManager sharedInstance].getCurrentWallet getAllKeys] toAddressAndAmount:array andHandler:^(NSError *error, id response) {
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

-(void)payWithToken:(NSString *)amountString {
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionToToken:self.token toAddress:self.addressTextField.text amount:@([amountString doubleValue]) andHandler:^(NSError* error, BTCTransaction * transaction, NSString* hashTransaction) {
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

- (void)showCompletedPopUp{
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator getContentForSend] presenter:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
}

- (void)showErrorPopUp{
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator getContentForOupsPopUp] presenter:[UIApplication sharedApplication].delegate.window.rootViewController completion:nil];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    if (self.token) {
        [self payWithToken:[self getCorrectAmountString]];
    } else {
        [self payWithWallet:[self getCorrectAmountString]];
    }
}

#pragma mark - iMessage

-(void)setAdress:(NSString*)adress andValue:(NSString*)amount{
    self.adress = adress;
    self.amount = amount;
    self.needUpdateTexfFields = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.amountTextField) {
        if ([string isEqualToString:@","]) {
            return ![textField.text containsString:string] && !(textField.text.length == 0);
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)addDoneButtonToAmountTextField {
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    toolbar.barTintColor = customBlackColor();
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    doneItem.tintColor = customBlueColor();
    toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneItem];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender {
    [self.amountTextField resignFirstResponder];
}

- (NSString *)getCorrectAmountString {
    NSMutableString *amountString = [self.amountTextField.text mutableCopy];
    if ([amountString containsString:@","]) {
        [amountString replaceCharactersInRange:[amountString rangeOfString:@","] withString:@"."];
    }
    return [NSString stringWithString:amountString];
}

#pragma mark - Action

- (IBAction)makePaymentButtonWasPressed:(id)sender {
    if (self.token) {
        [self payWithToken:[self getCorrectAmountString]];
    } else {
        [self payWithWallet:[self getCorrectAmountString]];
    }
}

- (IBAction)actionVoidTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)didPressedChoseTokensAction:(id)sender {
    ChoseTokenPaymentViewController* tokenController = (ChoseTokenPaymentViewController*)[[ControllersFactory sharedInstance] createChoseTokenPaymentViewController];
    tokenController.delegate = self;
    tokenController.activeToken = self.token;
    [self.navigationController pushViewController:tokenController animated:YES];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary{
    
    self.addressTextField.text =
    self.adress = dictionary[PUBLIC_ADDRESS_STRING_KEY];
    self.amountTextField.text =
    self.amount = dictionary[AMOUNT_STRING_KEY];
    [self updateControls];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TokenListViewControllerDelegate

- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item{
    self.token = item;
    self.tokenTextField.text = item.localName;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Contract*) item{
    
}

- (void)resetToDefaults{
    self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", @"");
    self.token = nil;
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"NewPaymentToQrCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        
        vc.delegate = self;
    }
}

@end
