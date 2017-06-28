//
//  QStoreContractViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreContractViewController.h"
#import "ContractFileManager.h"

@interface QStoreContractViewController () <PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation QStoreContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction)actionDetails:(id)sender {
    [self.delegate didSelectQStoreContractDetails];
}

- (IBAction)actionSourceCode:(id)sender {
    PopUpContent *content = [PopUpContentGenerator getContentForSourceCode];
    NSString *code = [[ContractFileManager sharedInstance] getContractWithTemplate:@"Standart"];
    content.messageString = code;
    
    [[PopUpsManager sharedInstance] showSourceCodePopUp:self withContent:content presenter:self completion:nil];
}

- (IBAction)actionPurchase:(id)sender {
    [[PopUpsManager sharedInstance] showConfirmPurchasePopUp:self presenter:self completion:nil];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
