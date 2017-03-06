//
//  CreateTokenStep4ViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenStep4ViewController.h"
#import "CreateTokenCoordinator.h"

@interface CreateTokenStep4ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tokenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokenSymbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *initialSupplyLabel;
@property (weak, nonatomic) IBOutlet UILabel *decimalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *freezingOfAssetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *automaticSellingAndBuingLabel;
@property (weak, nonatomic) IBOutlet UILabel *autorefillLabel;
@property (weak, nonatomic) IBOutlet UILabel *proofOfWorkLabel;

@end

@implementation CreateTokenStep4ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(void)configLabels{
    self.tokenNameLabel.text = self.tokenName;
    self.tokenSymbolLabel.text = self.tokenSymbol;
    self.freezingOfAssetsLabel.text = self.freezingOfAssets;
    self.autorefillLabel.text = self.autorefill;
    self.automaticSellingAndBuingLabel.text = self.automaticSellingAndBuing;
    self.proofOfWorkLabel.text = self.proofOfWork;
    self.decimalNumberLabel.text = self.decimalNumber;
    self.initialSupplyLabel.text = self.initialSupply;
}

#pragma mark - Actions

- (IBAction)actionFinish:(id)sender {
    [self.delegate createStepFourFinishDidPressed];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate createStepFourBackDidPressed];
}

@end
