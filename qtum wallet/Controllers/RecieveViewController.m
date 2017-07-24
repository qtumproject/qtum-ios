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

- (IBAction)backButtonWasPressed:(id)sender;
- (IBAction)shareButtonWasPressed:(id)sender;
- (IBAction)copeButtonWasPressed:(id)sender;
@end

@implementation RecieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addDoneButtonToAmountTextField];
    self.shareButton.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"%.3f", self.wallet.balance];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%.3f", self.wallet.unconfirmedBalance];
    
    self.publicAddressLabel.text = [ApplicationCoordinator sharedInstance].walletManager.wallet.mainAddress;
    self.publicAddressLabel.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self createQRCode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)createQRCode
{
    self.shareButton.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    NSString *qtumAddress = [ApplicationCoordinator sharedInstance].walletManager.wallet.mainAddress;
    NSString *tokenAddress = [self.wallet isKindOfClass:[Contract class]] ? self.wallet.mainAddress : nil;
    NSString *amountString = [self correctAmountString];
    
    [QRCodeManager createQRCodeFromPublicAddress:qtumAddress tokenAddress:tokenAddress andAmount:amountString forSize:self.qrCodeImageView.frame.size withCompletionBlock:^(UIImage *image) {
        weakSelf.qrCodeImageView.image = image;
        weakSelf.publicAddressLabel.hidden = NO;
        weakSelf.shareButton.enabled = YES;
        weakSelf.walletAdressCopyButton.enabled = YES;
        weakSelf.shareLabelButton.enabled = YES;
    }];
}

#pragma mark - UITextFieldDelegate

- (void)addDoneButtonToAmountTextField {
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    toolbar.barTintColor = customBlackColor();
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
    
    if ([string isEqualToString:@","]) {
        return ![textField.text containsString:string] && !(textField.text.length == 0);
    }
    
    return YES;
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

- (IBAction)shareButtonWasPressed:(id)sender
{
    NSString *text = self.publicAddressLabel.text;
    UIImage *qrCode = self.qrCodeImageView.image;
    
    double amount = [[self correctAmountString] doubleValue];
    if (amount > 0) {
        text = [NSString stringWithFormat:NSLocalizedString(@"My address: %@ and amount: %.3f", nil), text, amount];
    }
    
    NSArray *sharedItems = @[qrCode, text];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:sharingVC animated:YES completion:nil];
}

- (IBAction)copeButtonWasPressed:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    NSString* keyString = [ApplicationCoordinator sharedInstance].walletManager.wallet.mainAddress;
    [pb setString:keyString];
    
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForAddressCopied] presenter:nil completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
