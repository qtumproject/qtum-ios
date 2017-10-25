//
//  CreateTokenFinishViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "CreateTokenFinishViewController.h"
#import "ContractCoordinator.h"
#import "FinishInputCell.h"
#import "ResultTokenInputsModel.h"
#import "TextFieldWithLine.h"
#import "NSNumber+Comparison.h"

@interface CreateTokenFinishViewController () <PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Gas price and gas limit
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@property (weak, nonatomic) IBOutlet UIView *gasValuesContainer;
@property (weak, nonatomic) IBOutlet UIView *gasSlidersContainer;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *gasPriceMinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasPriceMaxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitMinValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *gasLimitMaxValueLabel;

@property (weak, nonatomic) IBOutlet UISlider *gasPriceSlider;
@property (weak, nonatomic) IBOutlet UISlider *gasLimitSlider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstratinForEdit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForGasSlidersContainer;

@property (nonatomic) long gasPriceStep;
@property (nonatomic) long gasLimitStep;
@property (nonatomic) long gasPriceMin;
@property (nonatomic) long gasLimitMin;

@property (strong, nonatomic) NSDecimalNumber* gasPrice;
@property (strong, nonatomic) NSDecimalNumber* gasLimit;

// Fee

@property (weak, nonatomic) IBOutlet UISlider *feeSlider;

@property (weak, nonatomic) IBOutlet TextFieldWithLine *feeTextField;
@property (weak, nonatomic) IBOutlet UILabel *minFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxFeeLabel;

@property (strong, nonatomic) NSDecimalNumber* minFee;
@property (strong, nonatomic) NSDecimalNumber* maxFee;
@property (strong, nonatomic) NSDecimalNumber* FEE;

@end

static NSInteger heightGasSlidersContainerClose = 0;
static NSInteger heightGasSlidersContainerOpen = 150;
static NSInteger closeTopForEditButton = 0;
static NSInteger openTopForEditButton = 15;

@implementation CreateTokenFinishViewController

@synthesize delegate, inputs;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -50, 0);
    [self configBottomGradientView];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark - Configuration

-(void)configBottomGradientView {
    self.bottomGradientView.colorType = DarkLong;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inputs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinishInputCell* cell = [tableView dequeueReusableCellWithIdentifier:FinishInputCellIdentifire];
    cell.name.text = self.inputs[indexPath.row].name;
    cell.value.text = [NSString stringWithFormat:@"%@",self.inputs[indexPath.row].value];

    return cell;
}

#pragma mark - Actions 

- (IBAction)didBackPressedAction:(id)sender {
    [self.delegate finishStepBackDidPressed];
}

- (IBAction)didFinishPressedAction:(id)sender {
    [self.delegate finishStepFinishDidPressed:self.FEE gasPrice:self.gasPrice gasLimit:self.gasLimit];
}

- (IBAction)didCancelPressed:(id)sender {
    [self.delegate finishStepCancelDidPressed];
}

- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionEditPressed:(id)sender {
    CGFloat inset;
    CGFloat changeOffset;
    if (self.heightForGasSlidersContainer.constant == heightGasSlidersContainerOpen) {
        self.heightForGasSlidersContainer.constant = heightGasSlidersContainerClose;
        self.topConstratinForEdit.constant = closeTopForEditButton;
        
        [self.editButton setTitle:NSLocalizedString(@"EDIT", nil) forState:UIControlStateNormal];
        
        inset = - 50;
        changeOffset = - heightGasSlidersContainerClose - closeTopForEditButton;
    } else {
        self.heightForGasSlidersContainer.constant = heightGasSlidersContainerOpen;
        self.topConstratinForEdit.constant = openTopForEditButton;
        
        [self.editButton setTitle:NSLocalizedString(@"CLOSE", nil) forState:UIControlStateNormal];
        
        inset = 85;
        changeOffset = heightGasSlidersContainerOpen + openTopForEditButton;
    }
    
    CGPoint contentOffset = self.tableView.contentOffset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.tableView setContentOffset:CGPointMake(contentOffset.x, contentOffset.y + changeOffset) animated:NO];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, inset, 0);
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)didChangeFeeSlider:(UISlider *) slider {
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithFloat:slider.value];
    self.FEE = sliderValue;
    self.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)didChangeGasPriceSlider:(UISlider *)slider {
    unsigned long value = self.gasPriceMin + (NSInteger)slider.value * self.gasPriceStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasPrice = sliderValue;
    self.gasPriceValueLabel.text = [[NSString stringWithFormat:@"%@", self.gasPrice] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)didChangeGasLimitSlider:(UISlider *)slider {
    unsigned long value = self.gasLimitMin + (NSInteger)slider.value * self.gasLimitStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasLimit = sliderValue;
    self.gasLimitValueLabel.text = [[NSString stringWithFormat:@"%@", self.gasLimit] stringByReplacingOccurrencesOfString:@"." withString:@","];
}
#pragma mark - methods

- (void)showCompletedPopUp{
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForCreateContract] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *)string {
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (string) {
        content.titleString = NSLocalizedString(@"Error", nil);
        content.messageString = string;
    }
    
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
}

- (void)setMinFee:(NSNumber*) minFee andMaxFee:(NSNumber*) maxFee {
    self.feeSlider.maximumValue = maxFee.floatValue;
    self.feeSlider.minimumValue = minFee.floatValue;
    self.feeSlider.value = 0.1f;
    self.FEE = [NSDecimalNumber decimalNumberWithString:@"0.1"];
    
    self.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
    self.minFeeLabel.text = [NSString stringWithFormat:@"%@", minFee];
    self.maxFeeLabel.text = [NSString stringWithFormat:@"%@", maxFee];
    
    self.maxFee = [maxFee decimalNumber];
    self.minFee = [minFee decimalNumber];
}

- (void)setMinGasPrice:(NSNumber *)min andMax:(NSNumber *)max step:(long)step {
    long count = ([max longValue] - [min longValue]) / step;
    self.gasPriceSlider.maximumValue = count;
    self.gasPriceSlider.minimumValue = 0;
    self.gasPriceSlider.value = 0;
    
    self.gasPriceMin = [min longLongValue];
    self.gasPriceStep = step;
    
    self.gasPrice = [[NSDecimalNumber alloc] initWithFloat:min.floatValue];
    
    self.gasPriceValueLabel.text = [min stringValue];
    self.gasPriceMinValueLabel.text = [min stringValue];
    self.gasPriceMaxValueLabel.text = [max stringValue];
}

- (void)setMinGasLimit:(NSNumber *)min andMax:(NSNumber *)max standart:(NSNumber *)standart step:(long)step {
    long count = ([max longValue] - [min longValue]) / step;
    long standartLong = ([standart longValue] - [min longValue]) / step;
    
    self.gasLimitSlider.maximumValue = count;
    self.gasLimitSlider.minimumValue = 0;
    self.gasLimitSlider.value = standartLong;
    
    self.gasLimitMin = [min longLongValue];
    self.gasLimitStep = step;
    
    self.gasLimit = [[NSDecimalNumber alloc] initWithFloat:standart.floatValue];
    
    self.gasLimitValueLabel.text = [standart stringValue];
    self.gasLimitMinValueLabel.text = [min stringValue];
    self.gasLimitMaxValueLabel.text = [max stringValue];
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

#pragma mark - TextFeild delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.feeTextField) {
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

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    [self.delegate didPressedQuit];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
