//
//  RecieveViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "RecieveViewController.h"
#import "TextFieldWithLine.h"
#import "QRCodeManager.h"

@interface RecieveViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *publicAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
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
    
    self.balanceLabel.text = self.balance;
    [self addDoneButtonToAmountTextField];
    self.shareButton.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.key) {
        self.key = [[WalletManager sharedInstance].getCurrentWallet getLastRandomKeyOrRandomKey];
        [self createQRCode];
        self.publicAddressLabel.text = self.key.addressTestnet.string;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)createQRCode
{
    self.shareButton.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    [QRCodeManager createQRCodeFromPublicAddress:self.key.addressTestnet.string andAmount:self.amountTextField.text forSize:self.qrCodeImageView.frame.size withCompletionBlock:^(UIImage *image) {
        weakSelf.qrCodeImageView.image = image;
        weakSelf.shareButton.enabled = YES;
        weakSelf.walletAdressCopyButton.enabled = YES;
        weakSelf.shareLabelButton.enabled = YES;
    }];
}

#pragma mark - UITextFieldDelegate

- (void)addDoneButtonToAmountTextField
{
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = [UIColor groupTableViewBackgroundColor];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)],
                      ];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender
{
    [self.amountTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.shareButton.enabled = NO;
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.shareButton.enabled = YES;
    [self createQRCode];
    
    return YES;
}

#pragma mark - Action

- (IBAction)backButtonWasPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonWasPressed:(id)sender
{
    NSString *text = self.publicAddressLabel.text;
    UIImage *qrCode = self.qrCodeImageView.image;
    
    NSArray *sharedItems = @[qrCode, text];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:sharingVC animated:YES completion:nil];
}

- (IBAction)copeButtonWasPressed:(id)sender
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.key.addressTestnet.string];
    
    [self showAlertWithTitle:nil mesage:@"Address copied" andActions:nil];
}
@end
