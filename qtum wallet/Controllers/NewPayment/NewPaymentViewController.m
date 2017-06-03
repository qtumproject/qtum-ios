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
#import "PopUpsManager.h"

@interface NewPaymentViewController () <UITextFieldDelegate, QRCodeViewControllerDelegate,ChoseTokenPaymentViewControllerDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet UIView *adressUnderlineView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet UIView *amountUnderlineView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *pinTextField;
@property (weak, nonatomic) IBOutlet UIView *pinUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *tokenUnderlineView;
@property (weak, nonatomic) IBOutlet UIButton *tokenButton;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenTextField;
@property (weak, nonatomic) IBOutlet UIImageView *tokenDisclousureImage;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;
@property (strong,nonatomic) NSString* adress;
@property (strong,nonatomic) NSString* amount;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withoutTokensConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withTokensConstraint;

@property (strong,nonatomic) Contract* token;

- (IBAction)backbuttonPressed:(id)sender;
- (IBAction)makePaymentButtonWasPressed:(id)sender;
@end

@implementation NewPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self addDoneButtonToAmountTextField];
    
    if (self.dictionary) {
        [self qrCodeScanned:self.dictionary];
    }
    
    BOOL isTokensExists = [TokenManager sharedInstance].getAllTokens.count;
    
    self.withTokensConstraint.active = isTokensExists;
    self.withoutTokensConstraint.active =
    self.tokenButton.hidden =
    self.tokenDisclousureImage.hidden =
    self.tokenUnderlineView.hidden = !isTokensExists;
    self.tokenDisclousureImage.tintColor = customBlueColor();
    self.tokenTextField.text =  NSLocalizedString(@"QTUM (Default)", @"");
    self.residueValueLabel.text = self.currentBalance;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateControls];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

-(void)updateControls{
    
    double amount = [self.amountTextField.text doubleValue];
    
    self.residueValueLabel.text = [NSString stringWithFormat:@"%.3f",[WalletManager sharedInstance].getCurrentWallet.balance - amount];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%.3f",[WalletManager sharedInstance].getCurrentWallet.unconfirmedBalance];
}

-(void)payWithWallet {
    
    NSNumber *amount = @([self.amountTextField.text doubleValue]);
    NSString *address = self.addressTextField.text;
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[WalletManager sharedInstance].getCurrentWallet getAllKeys] toAddressAndAmount:array andHandler:^(NSError *error, id response) {
        [SVProgressHUD dismiss];
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

-(void)payWithToken {
    
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[TransactionManager sharedInstance] sendTransactionToToken:self.token toAddress:self.addressTextField.text amount:@([self.amountTextField.text doubleValue]) andHandler:^(NSError* error, BTCTransaction * transaction, NSString* hashTransaction) {
        [SVProgressHUD dismiss];
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
    [self backbuttonPressed:self];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    if (self.token) {
        [self payWithToken];
    } else {
        [self payWithWallet];
    }
}

#pragma mark - iMessage

-(void)setAdress:(NSString*)adress andValue:(NSString*)amount{
    self.addressTextField.text =
    self.adress = adress;
    self.amountTextField.text =
    self.amount = amount;
    [self updateControls];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIColor* underlineColor = [UIColor colorWithRed:54/255. green:185/255. blue:200/255. alpha:1];

    if ([textField isEqual:self.addressTextField]) {
        self.adressUnderlineView.backgroundColor = underlineColor;
    }else if ([textField isEqual:self.amountTextField]) {
        self.amountUnderlineView.backgroundColor = underlineColor;
    }else if ([textField isEqual:self.pinTextField]) {
        self.pinUnderlineView.backgroundColor = underlineColor;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    UIColor* underlineColor = [UIColor colorWithRed:189/255. green:198/255. blue:207/255. alpha:1];
    if ([textField isEqual:self.addressTextField]) {
        self.adressUnderlineView.backgroundColor = underlineColor;
    }else if ([textField isEqual:self.amountTextField]) {
        self.amountUnderlineView.backgroundColor = underlineColor;
    }else if ([textField isEqual:self.pinTextField]) {
        self.pinUnderlineView.backgroundColor = underlineColor;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.amountTextField]) {
        NSMutableString *newString = [textField.text mutableCopy];
        [newString replaceCharactersInRange:range withString:string];
        NSString *complededString = [newString stringByReplacingOccurrencesOfString:@"," withString:@"."];
        [self calculateResidue:complededString];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)addDoneButtonToAmountTextField
{
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [UIColor groupTableViewBackgroundColor];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)],
                      ];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender
{
    [self.amountTextField resignFirstResponder];
}

- (void)calculateResidue:(NSString *)string {
    double amount;
    if (string) {
        amount = [string doubleValue];
    }else{
        amount = [self.amountTextField.text doubleValue];
    }
    double balance = [WalletManager sharedInstance].getCurrentWallet.balance;
    
    double residue = balance - amount;
    self.residueValueLabel.text = [NSString stringWithFormat:@"%lf", residue];
}

#pragma mark - Action

- (IBAction)backbuttonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)makePaymentButtonWasPressed:(id)sender {
    
    if (self.token) {
        [self payWithToken];
    } else {
        [self payWithWallet];
    }
}

- (IBAction)actionVoidTap:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)didPressedChoseTokensAction:(id)sender {
    ChoseTokenPaymentViewController* tokenController = (ChoseTokenPaymentViewController*)[[ControllersFactory sharedInstance] createChoseTokenPaymentViewController];
    tokenController.tokens = [[TokenManager sharedInstance] getAllTokens];
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
    self.tokenTextField.text = item.name;
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

-(IBAction)unwingToPayment:(UIStoryboardSegue *)segue {
//    StartNavigationCoordinator* coordinator = (StartNavigationCoordinator*)self.navigationController;
//    [coordinator clear];
}

@end
