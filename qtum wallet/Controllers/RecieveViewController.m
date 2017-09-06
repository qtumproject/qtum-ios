//
//  RecieveViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "RecieveViewController.h"
#import "TextFieldWithLine.h"
#import "QRCodeManager.h"
#import "Wallet.h"

@interface RecieveViewController () <UITextFieldDelegate, PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *publicAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *walletAdressCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *shareLabelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletCopyButtonBottomOffsetConstraint;
@property (weak, nonatomic) IBOutlet UIButton *chooseAddressButton;
@property (weak, nonatomic) IBOutlet UILabel *balanceCurrency;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalanceCurrency;

- (IBAction)backButtonWasPressed:(id)sender;
- (IBAction)shareButtonWasPressed:(id)sender;
- (IBAction)copyButtonWasPressed:(id)sender;

@end

@implementation RecieveViewController

@synthesize delegate = _delegate,
type = _type,
balanceText = _balanceText,
unconfirmedBalanceText = _unconfirmedBalanceText,
walletAddress = _walletAddress,
tokenAddress = _tokenAddress,
currency = _currency;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addDoneButtonToAmountTextField];
    self.shareButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.balanceLabel.text = self.balanceText;
    self.unconfirmedBalance.text = self.unconfirmedBalanceText;    
    self.publicAddressLabel.text = self.walletAddress;
    self.publicAddressLabel.hidden = YES;
    if (self.currency) {
        self.balanceCurrency.text =
        self.unconfirmedBalanceCurrency.text = self.currency;
    }
    
    self.walletCopyButtonBottomOffsetConstraint.constant = 90;
    self.chooseAddressButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self createQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)createQRCode {
    
    self.shareButton.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    NSString *qtumAddress = self.walletAddress;
    NSString *tokenAddress = self.tokenAddress;
    NSString *amountString = [self correctAmountString];
    
    [QRCodeManager createQRCodeFromPublicAddress:qtumAddress tokenAddress:tokenAddress andAmount:amountString forSize:self.qrCodeImageView.frame.size withCompletionBlock:^(UIImage *image) {
        weakSelf.qrCodeImageView.image = image;
        weakSelf.publicAddressLabel.hidden = NO;
        weakSelf.shareButton.enabled = YES;
        weakSelf.walletAdressCopyButton.enabled = YES;
        weakSelf.shareLabelButton.enabled = YES;
    }];
}

#pragma mark - Output

- (void)updateControls {
    
    self.balanceLabel.text = self.balanceText;
    self.unconfirmedBalance.text = self.unconfirmedBalanceText;
    self.publicAddressLabel.text = self.walletAddress;
}

#pragma mark - UITextFieldDelegate

- (void)addDoneButtonToAmountTextField {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    doneButton.tintColor = customBlueColor();
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender {
    [self.amountTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.shareButton.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.shareButton.enabled = YES;
    [self createQRCode];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isDecimal = newString.isDecimalString;
    
    return isDecimal;
}

- (NSString *)correctAmountString {
    
    NSMutableString *amountString = [self.amountTextField.text mutableCopy];
    if ([amountString containsString:@","]) {
        [amountString replaceCharactersInRange:[amountString rangeOfString:@","] withString:@"."];
    }
    return [NSString stringWithString:amountString];
}

#pragma mark - Action

- (IBAction)backButtonWasPressed:(id)sender
{
    [self.delegate didBackPressed];
}
- (IBAction)chooseAnotherAddressPress:(id)sender {
    
    [self.delegate didPressedChooseAddressWithPreviusAddress:self.walletAddress];
}

- (IBAction)shareButtonWasPressed:(id)sender {
    
    NSString *text = self.publicAddressLabel.text;
    UIImage *qrCode = self.qrCodeImageView.image;
    
    double amount = [[self correctAmountString] doubleValue];
    if (amount > 0) {
        text = [NSString stringWithFormat:NSLocalizedString(@"My address: %@ and amount: %.3f", nil), text, amount];
    }
    
    if (!text || !qrCode) {
        return;
    }
    
    NSArray *sharedItems = @[qrCode, text];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:sharingVC animated:YES completion:nil];
}

- (IBAction)copyButtonWasPressed:(id)sender {
    
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString* keyString = self.walletAddress;
    [pb setString:keyString];
    
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForAddressCopied] presenter:nil completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
