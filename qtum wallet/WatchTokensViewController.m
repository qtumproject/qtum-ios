//
//  WatchTokensViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WatchTokensViewController.h"
#import "TextFieldWithLine.h"
#import "InputTextView.h"
#import "ErrorPopUpViewController.h"

@interface WatchTokensViewController ()

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation WatchTokensViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}

#pragma mark - Output

- (void)setTokenName:(NSString*) tokenName {
    
    if (self.contractNameField.text.length == 0) {
        self.contractNameField.text = tokenName;
    }
}
#pragma mar - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* text = [textField.text stringByAppendingString:string];
    BOOL isValid = YES;
    if ([textField isEqual:self.contractAddressTextField]) {
        isValid = [SLocator.validationInputService isValidSymbolsContractAddressString:text];
        if (isValid) {
            [self.delegate didEnterValidAddress:text];
        }
    }
    return isValid;
}


#pragma mark - Actions

- (IBAction)actionVoidTap:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)didPressedBackAction:(id) sender {
    
    [self.delegate didPressedBack];
}

- (IBAction)didPressedOkAction:(id) sender {
    
    [self actionVoidTap:nil];
    [self.delegate didPressedCreateTokenWithName:self.contractNameField.text andAddress:self.contractAddressTextField.text];
}

- (IBAction)didPressedCancelAction:(id) sender {
    [self.delegate didPressedBack];
}

@end
