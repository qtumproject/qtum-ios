//
//  ImportKeyViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 24.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ImportKeyViewController.h"
#import "TextFieldWithLine.h"
#import "QRCodeViewController.h"
#import "KeysManager.h"

@interface ImportKeyViewController () <UITextFieldDelegate, QRCodeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;

- (IBAction)importButtonWasPressed:(id)sender;
- (IBAction)backButtonWasPressed:(id)sender;

@end

@implementation ImportKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSString *)string
{
    self.addressTextField.text = string;
}

#pragma mark - Actions

- (IBAction)importButtonWasPressed:(id)sender
{
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [KeysManager sharedInstance].keyRegistered = ^(BOOL registered){
        if (registered) {
            [SVProgressHUD showSuccessWithStatus:@"Done"];
            [weakSelf dismissViewControllerAnimated:YES completion:^(){
                if ([weakSelf.delegate respondsToSelector:@selector(addressImported)]) {
                    [weakSelf.delegate addressImported];
                }
            }];
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"Some Error"];
        }
        [KeysManager sharedInstance].keyRegistered = nil;
    };
    [[KeysManager sharedInstance] importKey:self.addressTextField.text];
}

- (IBAction)backButtonWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"ImportToQRCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
