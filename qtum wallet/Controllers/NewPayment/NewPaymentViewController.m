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
#import "InformationPopUpViewController.h"
#import "SecurityPopupViewController.h"

@interface NewPaymentViewController () <UITextFieldDelegate, PopUpWithTwoButtonsViewControllerDelegate>

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

@property (nonatomic) BOOL needUpdateTexfFields;

- (IBAction)makePaymentButtonWasPressed:(id)sender;

@end

static NSInteger withTokenOffset = 80;
static NSInteger withoutTokenOffset = 30;

@implementation NewPaymentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", @"");
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.needUpdateTexfFields) {
        self.addressTextField.text = self.adress;
        self.amountTextField.text = self.amount;
    }
    
    [self.delegate didViewLoad];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NewPaymentOutput

-(void)updateControlsWithTokenExist:(BOOL) isExist
                      walletBalance:(CGFloat) walletBalance
             andUnconfimrmedBalance:(CGFloat) walletUnconfirmedBalance {
    
    //updating constraints and activity info
    self.residueValueLabel.text = [NSString stringWithFormat:@"%.3f", walletBalance];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%.3f", walletUnconfirmedBalance];

    BOOL isTokensExists = isExist;
    self.tokenTextField.hidden =
    self.tokenButton.hidden =
    self.tokenDisclousureImage.hidden = !isTokensExists;
    self.withoutTokensConstraint.constant = isTokensExists ? withTokenOffset : withoutTokenOffset;
    self.tokenDisclousureImage.tintColor = customBlueColor();
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}


- (void)showLoaderPopUp {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
}

- (void)showCompletedPopUp{
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp{
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator contentForOupsPopUp] presenter:nil completion:nil];
}

- (void)hideLoaderPopUp {
    [[PopUpsManager sharedInstance] dismissLoader];
}

- (void)clearFields {
    
    self.addressTextField.text = @"";
    self.amountTextField.text = @"";
    self.amount = nil;
    self.adress = nil;
}

-(void)updateContentWithContract:(Contract*) contract {
    
    self.tokenTextField.text = contract ? contract.localName : NSLocalizedString(@"QTUM (Default)", @"");
}

-(void)updateContentFromQRCode:(NSDictionary*) qrCodeDict {
    
    self.addressTextField.text =
    self.adress = qrCodeDict[PUBLIC_ADDRESS_STRING_KEY];
    self.amountTextField.text =
    self.amount = qrCodeDict[AMOUNT_STRING_KEY];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    if ([sender isKindOfClass:[InformationPopUpViewController class]]) {
        [self clearFields];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - iMessage

-(void)setAdress:(NSString*)adress andValue:(NSString*)amount {
    
    self.adress = adress;
    self.amount = amount;
    self.needUpdateTexfFields = YES;
}

#pragma mark - UITextFieldDelegate

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

- (NSString *)correctAmountString {
    
    NSMutableString *amountString = [self.amountTextField.text mutableCopy];
    if ([amountString containsString:@","]) {
        [amountString replaceCharactersInRange:[amountString rangeOfString:@","] withString:@"."];
    }
    return [NSString stringWithString:amountString];
}

#pragma mark - Action

- (IBAction)makePaymentButtonWasPressed:(id)sender {
    
    NSNumber *amount = @([[self correctAmountString] doubleValue]);
    NSString *address = self.addressTextField.text;
    [self.delegate didPresseSendActionWithAddress:address andAmount:amount];

}

- (IBAction)actionVoidTap:(id)sender{
    
    [self.view endEditing:YES];
}

- (IBAction)didPressedChoseTokensAction:(id)sender {
    
    [self.delegate didPresseChooseToken];
}

- (IBAction)didPressedScanQRCode:(id)sender {
    
    [self.delegate didPresseQRCodeScaner];
}


@end
