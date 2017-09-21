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
#import "ErrorPopUpViewController.h"
#import "SecurityPopupViewController.h"
#import "NSNumber+Comparison.h"

@interface NewPaymentViewController () <UITextFieldDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *tokenTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *feeTextField;

@property (weak, nonatomic) IBOutlet UIButton *tokenButton;
@property (weak, nonatomic) IBOutlet UIImageView *tokenDisclousureImage;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UISlider *feeSlider;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withoutTokensConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *minFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxFeeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fromAmountToSendButtonOffset;


@property (strong,nonatomic) NSString* adress;
@property (strong,nonatomic) NSString* amount;
@property (strong,nonatomic) NSDecimalNumber* FEE;
@property (strong,nonatomic) NSDecimalNumber* minFee;
@property (strong,nonatomic) NSDecimalNumber* maxFee;


@property (nonatomic) CGFloat standartTopOffsetForSendButton;

@property (nonatomic) BOOL needUpdateTexfFields;
@property (nonatomic) BOOL isTokenChoosen;


- (IBAction)makePaymentButtonWasPressed:(id)sender;

@end

static NSInteger withTokenOffset = 100;
static NSInteger withoutTokenOffset = 40;

@implementation NewPaymentViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    self.sendButtomBottomOffset = 27;
    self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", @"");
    
    [self configFee];
    
    [self.amountTextField setEnablePast:NO];
    
    [self.amountTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
    [self.addressTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self updateTextFields];
    [self.delegate didViewLoad];
    [self updateScrollsConstraints];
    //[self updateFeeInputs];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self updateSendButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:NO];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)configFee {
    
    [self.feeTextField setEnablePast:NO];
    self.feeSlider.minimumValue = 0.001f;
    self.feeSlider.maximumValue = 0.2f;
    self.feeSlider.value = 0.1;
    self.FEE = [NSDecimalNumber decimalNumberWithString:@"0.1"];
    self.feeTextField.text = @"0,1";
}

-(void)updateFeeInputs {
    
    self.feeSlider.hidden = self.isTokenChoosen;
    self.feeTextField.hidden = self.isTokenChoosen;
    self.maxFeeLabel.hidden = self.isTokenChoosen;
    self.minFeeLabel.hidden = self.isTokenChoosen;
    self.fromAmountToSendButtonOffset.constant = self.isTokenChoosen ? 40 : 210;
}

- (void)updateTextFields {
    
    if (self.needUpdateTexfFields && self.addressTextField && self.amountTextField) {
        self.addressTextField.text = self.adress;
        self.amountTextField.text = self.amount;
        self.needUpdateTexfFields = NO;
    }
}

-(void)updateSendButton {
    
    BOOL isFilled = [self isTextFieldsFilled];
    
    self.sendButton.enabled = isFilled;
    self.sendButton.alpha = isFilled ? 1 : 0.5f;
}

-(void)normalizeFee {
    
    NSString* feeValueString = [self.feeTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSDecimalNumber *feeValue = [NSDecimalNumber decimalNumberWithString:feeValueString];
    
    if ([feeValue isGreaterThan:self.maxFee] ) {
        
        self.feeTextField.text = [NSString stringWithFormat:@"%@", self.maxFee];;
        self.FEE = self.maxFee;
        
    } else if ([feeValue isLessThan:self.minFee]) {
        
        self.feeTextField.text = [NSString stringWithFormat:@"%@", self.minFee];
        self.FEE = self.minFee;
    } else {
        
        self.FEE = feeValue;
    }
}

-(BOOL)isTextFieldsFilled {
    
    BOOL isFilled = YES;
    for (TextFieldWithLine *textField in self.scrollView.subviews) {
        if ([textField isKindOfClass:[TextFieldWithLine class]] && textField.text.length == 0) {
            isFilled = NO;
        }
    }
    return isFilled;
}

- (void)updateScrollsConstraints {
 
    CGFloat allHeight = self.scrollView.frame.size.height;
    CGFloat maxTextField = self.amountTextField.frame.size.height + self.amountTextField.frame.origin.y;
    CGFloat buttonHeight = self.sendButtomBottomOffset + self.sendButtonHeightConstraint.constant;
    
    self.sendButtonTopConstraint.constant = allHeight - maxTextField - buttonHeight;
    self.standartTopOffsetForSendButton = self.sendButtonTopConstraint.constant;
    
    [self.view layoutIfNeeded];
}

#pragma mark - NewPaymentOutput

-(void)updateControlsWithTokensExist:(BOOL) isExist
                  choosenTokenExist:(BOOL) choosenExist
                      walletBalance:(NSNumber*) walletBalance
             andUnconfimrmedBalance:(NSNumber*) walletUnconfirmedBalance {
    
    //updating constraints and activity info
    self.residueValueLabel.text = [NSString stringWithFormat:@"%@", [walletBalance.decimalNumber roundedNumberWithScale:3]];
    self.unconfirmedBalance.text = [NSString stringWithFormat:@"%@", [walletUnconfirmedBalance.decimalNumber roundedNumberWithScale:3]];

    BOOL isTokensExists = isExist;
    self.tokenTextField.hidden =
    self.tokenButton.hidden =
    self.tokenDisclousureImage.hidden = !isTokensExists;
    self.withoutTokensConstraint.constant = isTokensExists ? withTokenOffset : withoutTokenOffset;
    self.tokenDisclousureImage.tintColor = customBlueColor();
    
    if (!choosenExist) {
        self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", nil);
        self.isTokenChoosen = NO;
    }
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self updateScrollsConstraints];
}


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

- (void)clearFields {
    
    self.addressTextField.text = @"";
    self.amountTextField.text = @"";
    self.amount = nil;
    self.adress = nil;
}

-(void)updateContentWithContract:(Contract*) contract {
    
    self.tokenTextField.text = contract ? contract.localName : NSLocalizedString(@"QTUM (Default)", @"");
    self.isTokenChoosen = contract;
}

- (void)setMinFee:(NSNumber*) minFee andMaxFee:(NSNumber*) maxFee {
    
    self.feeSlider.maximumValue = maxFee.floatValue;
    self.feeSlider.minimumValue = minFee.floatValue;
    self.feeSlider.value = 0.1f;
    self.FEE = [NSDecimalNumber decimalNumberWithString:@"0.1"];
    
    self.minFeeLabel.text = [NSString stringWithFormat:@"%@", minFee];
    self.maxFeeLabel.text = [NSString stringWithFormat:@"%@", maxFee];
    
    self.maxFee = [maxFee decimalNumber];
    self.minFee = [minFee decimalNumber];
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

- (void)setSendInfoItem:(SendInfoItem *)item {
    
    if (item.qtumAddressKey) {
        self.adress = item.qtumAddressKey.address.string;
    } else {
        self.adress = item.qtumAddress;
    }
    self.amount = item.amountString;
    self.needUpdateTexfFields = YES;
    
    [self updateTextFields];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.amountTextField) {
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            return ![textField.text containsString:string] && !(textField.text.length == 0);
        }
    } else if (textField == self.feeTextField) {
        
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            
            return ![textField.text containsString:string] && !(textField.text.length == 0);
            
        } else {
            
            NSString* feeValueString = [[textField.text stringByAppendingString:string] stringByReplacingOccurrencesOfString:@"," withString:@"."];
            NSDecimalNumber *feeValue = [NSDecimalNumber decimalNumberWithString:feeValueString];
            
           [self.feeSlider setValue:feeValue.floatValue animated:YES];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.feeTextField) {
        
        [self normalizeFee];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)addDoneButtonToAmountTextField {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
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
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:[self correctAmountString]];
    
    NSString *address = self.addressTextField.text;
    
    [self normalizeFee];

    [self.delegate didPresseSendActionWithAddress:address andAmount:amount andFee:self.FEE];
}

- (IBAction)didChangeFeeSlider:(UISlider*) slider {
    
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithFloat:slider.value];
    self.FEE = sliderValue;
    self.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
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

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    
    NSDictionary *info = [sender userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.sendButtonTopConstraint.constant = 40.0f;
    self.sendButtonBottomConstraint.constant = kbSize.height - 30.0f;
    [self.view layoutIfNeeded];
}

-(void)keyboardDidShow:(NSNotification *)sender {
    
    UITextField* highlightedTextField;
    
    if ([self.amountTextField isFirstResponder]) {
        
        highlightedTextField = self.amountTextField;
    } else if ([self.feeTextField isFirstResponder]){
        
        highlightedTextField = self.feeTextField;
    } else {
        
        return;
    }
    
    NSDictionary *info = [sender userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = kbSize.height - 50.0f;
    CGFloat topOfKeyboard = self.scrollView.frame.size.height - kbHeight;
    
    CGFloat offset = highlightedTextField.frame.origin.y - topOfKeyboard;
    
    if (offset > 0) {
        
        CGPoint bottomOffset = CGPointMake(0, offset + 20);
        [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
}

-(void)keyboardWillHide:(NSNotification *)sender{
    
    self.sendButtonTopConstraint.constant = self.standartTopOffsetForSendButton;
    self.sendButtonBottomConstraint.constant = self.sendButtomBottomOffset;
    [self.view layoutIfNeeded];
}


@end
