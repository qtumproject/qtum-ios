//
//  CreateTokenFinishViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "CreateTokenFinishViewController.h"
#import "FinishInputCell.h"
#import "TextFieldWithLine.h"

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

@property (strong, nonatomic) QTUMBigNumber* gasPrice;
@property (strong, nonatomic) QTUMBigNumber* gasLimit;

// Fee

@property (weak, nonatomic) IBOutlet UISlider *feeSlider;

@property (weak, nonatomic) IBOutlet TextFieldWithLine *feeTextField;
@property (weak, nonatomic) IBOutlet UILabel *minFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxFeeLabel;

@property (strong, nonatomic) QTUMBigNumber* minFee;
@property (strong, nonatomic) QTUMBigNumber* maxFee;
@property (strong, nonatomic) QTUMBigNumber* FEE;

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    self.FEE = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
    self.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)didChangeGasPriceSlider:(UISlider *)slider {
    unsigned long value = self.gasPriceMin + (NSInteger)slider.value * self.gasPriceStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasPrice = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
    self.gasPriceValueLabel.text = [[NSString stringWithFormat:@"%@", self.gasPrice] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)didChangeGasLimitSlider:(UISlider *)slider {
    unsigned long value = self.gasLimitMin + (NSInteger)slider.value * self.gasLimitStep;
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
    self.gasLimit = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
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

- (void)setMinFee:(QTUMBigNumber*) minFee andMaxFee:(QTUMBigNumber*) maxFee {
    
    self.feeSlider.maximumValue = [maxFee decimalNumber].floatValue;
    self.feeSlider.minimumValue = [minFee decimalNumber].floatValue;
    self.feeSlider.value = 0.1f;
    self.FEE = [QTUMBigNumber decimalWithString:@"0.1"];
    
    self.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
    self.minFeeLabel.text = [NSString stringWithFormat:@"%@", minFee.stringValue];
    self.maxFeeLabel.text = [NSString stringWithFormat:@"%@", maxFee.stringValue];
    
    self.maxFee = maxFee;
    self.minFee = minFee;
}

- (void)setMinGasPrice:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max step:(long)step {
    
    long count = ([max integerValue] - [min integerValue]) / step;
    self.gasPriceSlider.maximumValue = count;
    self.gasPriceSlider.minimumValue = 0;
    self.gasPriceSlider.value = 0;
    
    self.gasPriceMin = [min integerValue];
    self.gasPriceStep = step;
    
    self.gasPrice = min;
    
    self.gasPriceValueLabel.text = [min stringValue];
    self.gasPriceMinValueLabel.text = [min stringValue];
    self.gasPriceMaxValueLabel.text = [max stringValue];
}

- (void)setMinGasLimit:(QTUMBigNumber *)min andMax:(QTUMBigNumber *)max standart:(QTUMBigNumber *)standart step:(long)step {
    
    long count = ([max integerValue] - [min integerValue]) / step;
    long standartLong = ([standart integerValue] - [min integerValue]) / step;
    
    self.gasLimitSlider.maximumValue = count;
    self.gasLimitSlider.minimumValue = 0;
    self.gasLimitSlider.value = standartLong;
    
    self.gasLimitMin = [min integerValue];
    self.gasLimitStep = step;
    
    self.gasLimit = [QTUMBigNumber decimalWithString:standart.stringValue];
    
    self.gasLimitValueLabel.text = [standart stringValue];
    self.gasLimitMinValueLabel.text = [min stringValue];
    self.gasLimitMaxValueLabel.text = [max stringValue];
}

-(void)normalizeFee {
    
    QTUMBigNumber* feeValue = [QTUMBigNumber decimalWithString:self.feeTextField.text];
    
    if ([feeValue isGreaterThan:self.maxFee] ) {
        
        self.feeTextField.text = [NSString stringWithFormat:@"%@", self.maxFee.stringValue];
        self.FEE = self.maxFee;
        
    } else if ([feeValue isLessThan:self.minFee]) {
        
        self.feeTextField.text = [NSString stringWithFormat:@"%@", self.minFee.stringValue];
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
 
            QTUMBigNumber* feeValue = [QTUMBigNumber decimalWithString:textField.text];
            [self.feeSlider setValue:[feeValue decimalNumber].floatValue animated:YES];
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
