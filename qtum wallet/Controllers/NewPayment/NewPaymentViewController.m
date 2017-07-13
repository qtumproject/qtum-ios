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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedBalance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *withoutTokensConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendButtonHeightConstraint;


@property (strong,nonatomic) NSString* adress;
@property (strong,nonatomic) NSString* amount;
@property (nonatomic) CGFloat standartTopOffsetForSendButton;

@property (nonatomic) BOOL needUpdateTexfFields;

- (IBAction)makePaymentButtonWasPressed:(id)sender;

@end

static NSInteger withTokenOffset = 100;
static NSInteger withoutTokenOffset = 40;
static NSInteger sendButtomBottomOffset = 27;

@implementation NewPaymentViewController

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

    
    self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", @"");
    
    [self.amountTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
    [self.addressTextField addTarget:self action:@selector(updateSendButton) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.needUpdateTexfFields) {
        self.addressTextField.text = self.adress;
        self.amountTextField.text = self.amount;
    }
    
    [self.delegate didViewLoad];
    [self updateScrollsConstraints];
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

-(void)updateSendButton {
    
    BOOL isFilled = [self isTextFieldsFilled];
    
    self.sendButton.enabled = isFilled;
    self.sendButton.alpha = isFilled ? 1 : 0.7f;
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
    CGFloat buttonHeight = sendButtomBottomOffset + self.sendButtonHeightConstraint.constant;
    
    self.sendButtonTopConstraint.constant = allHeight - maxTextField - buttonHeight;
    self.standartTopOffsetForSendButton = self.sendButtonTopConstraint.constant;
    
    [self.view layoutIfNeeded];
}

#pragma mark - NewPaymentOutput

-(void)updateControlsWithTokensExist:(BOOL) isExist
                  choosenTokenExist:(BOOL) choosenExist
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
    
    if (!choosenExist) {
        self.tokenTextField.text = NSLocalizedString(@"QTUM (Default)", nil);
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
    
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
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

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    
    NSDictionary *info = [sender userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.sendButtonTopConstraint.constant = 40.0f;
    self.sendButtonBottomConstraint.constant = kbSize.height - 30.0f;
    [self.view layoutIfNeeded];
}

-(void)keyboardDidShow:(NSNotification *)sender {
    
    if ([self.amountTextField isFirstResponder]) {
        NSDictionary *info = [sender userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGFloat kbHeight = kbSize.height - 50.0f;
        CGFloat topOfKeyboard = self.scrollView.frame.size.height - kbHeight;
        
        CGFloat bottomSend = self.sendButton.frame.size.height + self.sendButton.frame.origin.y;
        
        CGFloat forTopOffset = bottomSend - topOfKeyboard;
        if (forTopOffset > 0) {
            
            CGPoint bottomOffset = CGPointMake(0, forTopOffset + 20);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
        }
    }
}

-(void)keyboardWillHide:(NSNotification *)sender{
    
    self.sendButtonTopConstraint.constant = self.standartTopOffsetForSendButton;
    self.sendButtonBottomConstraint.constant = sendButtomBottomOffset;
    [self.view layoutIfNeeded];
}


@end
