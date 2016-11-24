//
//  InformationViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 31.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "InformationViewController.h"
#import "RequestManager.h"
#import "TransactionManager.h"
#import "BlockchainInfoManager.h"
#import "RPCRequestManager.h"
#import "KeysManager.h"

@interface InformationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *toAddressTextField;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)exit:(id)sender;
- (IBAction)send:(id)sender;

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    __weak typeof(self) weakSelf = self;
//    [[RequestManager sharedInstance] getBalanceByKey:self.selectedKey.uncompressedPublicKeyAddress.string withSuccessHandler:^(id responseObject) {
//        NSLog(@"%@", responseObject);
//        weakSelf.informationLabel.text = [NSString stringWithFormat:@"%@", responseObject];
//    } andFailureHandler:^(NSString *message) {
//        NSLog(@"%@", message);
//    }];
    
    __weak typeof(self) weakSelf = self;
    NSMutableArray *array = [NSMutableArray new];
    for (BTCKey *key in [KeysManager sharedInstance].keys) {
        [array addObject:key.address.string];
    }
    
    [BlockchainInfoManager getBalanceForAddreses:array withSuccessHandler:^(double responseObject) {
        weakSelf.informationLabel.text = [NSString stringWithFormat:@"%lf", responseObject];
    } andFailureHandler:^(NSError *error, NSString *message) {
        weakSelf.informationLabel.text = error.description;
    }];
//
//    if (self.nextKey) {
//        self.toAddressTextField.text = self.nextKey.addressTestnet.string;
//    }
//
//    [[RPCRequestManager sharedInstance] sendToAddress:self.selectedKey.addressTestnet.string withSuccessHandler:^(id responseObject) {
//        NSLog(@"%@", responseObject);
//    } andFailureHandler:^(NSError *error, NSString *message) {
//        NSLog(@"%@", error);
//    }];
//    
//    [[RPCRequestManager sharedInstance] generate:^(id responseObject) {
//        NSLog(@"%@", responseObject);
//    } andFailureHandler:^(NSError *error, NSString *message) {
//        NSLog(@"%@", error);
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)send:(id)sender
{
//    TransactionManager *transactionManager = [[TransactionManager alloc] initWithSendingValue:@([self.amountTextField.text doubleValue]) toAddress:self.toAddressTextField.text];
//    
//    self.statusLabel.text = @"Loading";
//    __weak typeof(self) weakSelf = self;
//    [transactionManager sendTransactionWithSuccess:^{
//        weakSelf.statusLabel.text = @"Success";
//    } andFailure:^{
//        weakSelf.statusLabel.text = @"Failure";
//    }];
    
    NSArray *array = @[@{@"amount" : @(33), @"address" : @"miGJKkY56qiTfU4Z2hJviB7QYu7YAWYtWw"}, @{@"amount" : @(33), @"address" : @"mg67Qy5SEJL8NrHMQ7CZCFDUSGd7AKyXNZ"}, @{@"amount" : @(33), @"address" : @"mgtrakKpqbnbJDmpsX1dTotoLXGrs4hk21"}];
    
    TransactionManager *transactionManager = [[TransactionManager alloc] initWith:array];
    
    self.statusLabel.text = @"Loading";
    __weak typeof(self) weakSelf = self;
    [transactionManager sendTransactionWithSuccess:^{
        weakSelf.statusLabel.text = @"Success";
    } andFailure:^(NSString *message){
        weakSelf.statusLabel.text = @"Failure";
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
