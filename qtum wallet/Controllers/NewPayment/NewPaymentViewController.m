//
//  NewPaymentViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "NewPaymentViewController.h"
#import "TransactionManager.h"
#import "QRCodeViewController.h"
#import "TextFieldWithLine.h"

@interface NewPaymentViewController () <UITextFieldDelegate, QRCodeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewheightConstraint;
@property (weak, nonatomic) IBOutlet UIView *currentBalanceView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *residueLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueValueLabel;

- (IBAction)backbuttonPressed:(id)sender;
- (IBAction)makePaymentButtonWasPressed:(id)sender;
@end

@implementation NewPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.balanceLabel.text = self.currentBalance;
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addDoneButtonToAmountTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self changeResidueHidden:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.amountTextField]) {
        [self changeResidueHidden:NO];
        [self calculateResidue:nil];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.amountTextField]) {
        [self changeResidueHidden:YES];
    }
    
    return YES;
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
                      [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)],
                      ];
    [toolbar sizeToFit];
    
    self.amountTextField.inputAccessoryView = toolbar;
}

- (void)done:(id)sender
{
    [self.amountTextField resignFirstResponder];
}

- (void)changeResidueHidden:(BOOL)hidden
{
    self.residueLabel.hidden = hidden;
    self.residueValueLabel.hidden = hidden;
}

- (void)calculateResidue:(NSString *)string
{
    double amount;
    if (string) {
        amount = [string doubleValue];
    }else{
        amount = [self.amountTextField.text doubleValue];
    }
    double balance = [self.balanceLabel.text doubleValue];
    
    double residue = balance - amount;
    self.residueValueLabel.text = [NSString stringWithFormat:@"%lf", residue];
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat kbDuration = [number floatValue];
    
    self.currentBalanceView.hidden = YES;
    [self animateTopViewWithDuration:kbDuration consraintValue:64.0f];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGFloat kbDuration = [number floatValue];
    
    self.currentBalanceView.hidden = NO;
    [self animateTopViewWithDuration:kbDuration consraintValue:174.0f];
}

- (void)animateTopViewWithDuration:(CGFloat)duration consraintValue:(CGFloat)value
{
    self.topViewheightConstraint.constant = value;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutSubviews];
    }];
}

#pragma mark - Action

- (IBAction)backbuttonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)makePaymentButtonWasPressed:(id)sender
{
    NSNumber *amount = @([self.amountTextField.text doubleValue]);
    NSString *address = self.addressTextField.text;
    
    NSArray *array = @[@{@"amount" : amount, @"address" : address}];
    
    TransactionManager *transactionManager = [[TransactionManager alloc] initWith:array];
    
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [transactionManager sendTransactionWithSuccess:^{
        [SVProgressHUD showSuccessWithStatus:@"Done"];
        [weakSelf backbuttonPressed:nil];
    } andFailure:^(NSString *message){
        [SVProgressHUD dismiss];
        [weakSelf showAlertWithTitle:@"Error" mesage:message andActions:nil];
    }];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
    self.addressTextField.text = string;
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"NewPaymentToQRCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        
        vc.delegate = self;
    }
}

@end
