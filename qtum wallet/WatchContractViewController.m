//
//  WatchContractViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 09.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WatchContractViewController.h"
#import "TextFieldWithLine.h"
#import "ImputTextView.h"

@interface WatchContractViewController ()

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet ImputTextView *abiTextView;

@end

@implementation WatchContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Private Methods

-(void)createSmartContract {
    if ([[TokenManager sharedInstance] addNewContractWithContractAddress:self.contractAddressTextField.text withAbi:self.abiTextView.text andWithName:self.contractNameField.text]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
        [self.delegate didPressedBack];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Error", "")];
    }
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didPressedOkAction:(id)sender {
    [SVProgressHUD show];
    [self createSmartContract];
}

- (IBAction)didPressedCancelAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

@end
