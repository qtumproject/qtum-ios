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

NSString* const textViewPlaceholder = @"Import Brand Key";

@interface ImportKeyViewController () <UITextFieldDelegate, QRCodeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *addressTextField;
@property (weak, nonatomic) IBOutlet UITextView *brandKeyTextView;
@property (strong,nonatomic) NSString* brandKeyString;

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


#pragma mark - Private Methods

-(NSArray*)arrayOfWordsFromString:(NSString*)aString{
    NSArray *array = [aString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != ''"]];
    return array;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:textViewPlaceholder]) {
        textView.text = @"";
        textView.textColor = [UIColor colorWithRed:78/255. green:93/255. blue:111/255. alpha:1];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = textViewPlaceholder;
        textView.textColor = [UIColor lightGrayColor];
        self.brandKeyString = @"";
    } else {
        self.brandKeyString = textView.text;
    }
}
#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary
{
    self.addressTextField.text = dictionary[PRIVATE_ADDRESS_STRING_KEY];;
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

- (IBAction)outsideTap:(id)sender{
    [self.brandKeyTextView resignFirstResponder];
    NSArray* array = [self arrayOfWordsFromString:self.brandKeyTextView.text];
    
}

- (IBAction)backButtonWasPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"ImportPtivateToQRCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
