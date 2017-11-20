//
//  SliderFeeView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SliderFeeView.h"

@interface SliderFeeView ()

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

@end

static NSInteger heightGasSlidersContainerClose = 0;
static NSInteger heightGasSlidersContainerOpen = 150;
static NSInteger closeTopForEditButton = 0;
static NSInteger openTopForEditButton = 15;

@implementation SliderFeeView

- (IBAction)didSliderAction:(id) sender {
	[self.delegate didChangeFeeSlider:sender];
}

- (IBAction)didGasPriceChangedAction:(UISlider *) slider {

	unsigned long value = self.gasPriceMin + (NSInteger)slider.value * self.gasPriceStep;
	NSDecimalNumber *sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
	QTUMBigNumber *bigNum = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
	[self.delegate didChangeGasPriceSlider:bigNum];
	self.gasPriceValueLabel.text = [[NSString stringWithFormat:@"%@", sliderValue] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)didGasLimitChangedAction:(UISlider *) slider {

	unsigned long value = self.gasLimitMin + (NSInteger)slider.value * self.gasLimitStep;
	NSDecimalNumber *sliderValue = [[NSDecimalNumber alloc] initWithUnsignedLong:value];
	QTUMBigNumber *bigNum = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
	[self.delegate didChangeGasLimiteSlider:bigNum];
	self.gasLimitValueLabel.text = [[NSString stringWithFormat:@"%@", sliderValue] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (IBAction)actionEdit:(id) sender {
	if (self.heightForGasSlidersContainer.constant == heightGasSlidersContainerOpen) {
		self.heightForGasSlidersContainer.constant = heightGasSlidersContainerClose;
		self.topConstratinForEdit.constant = closeTopForEditButton;

		[self.editButton setTitle:NSLocalizedString(@"EDIT", nil) forState:UIControlStateNormal];
	} else {
		self.heightForGasSlidersContainer.constant = heightGasSlidersContainerOpen;
		self.topConstratinForEdit.constant = openTopForEditButton;

		[self.editButton setTitle:NSLocalizedString(@"CLOSE", nil) forState:UIControlStateNormal];
	}

	[UIView animateWithDuration:0.3f animations:^{
		[self.superview layoutIfNeeded];
	}];
}

- (void)setMinGasPrice:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max step:(long) step {

	long count = ([max integerValue] - [min integerValue]) / step;
	self.gasPriceSlider.maximumValue = count;
	self.gasPriceSlider.minimumValue = 0;
	self.gasPriceSlider.value = 0;

	self.gasPriceMin = [min integerValue];
	self.gasPriceStep = step;

	self.gasPriceValueLabel.text = [min stringValue];
	self.gasPriceMinValueLabel.text = [min stringValue];
	self.gasPriceMaxValueLabel.text = [max stringValue];
}

- (void)setMinGasLimit:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max standart:(QTUMBigNumber *) standart step:(long) step; {
	long count = ([max integerValue] - [min integerValue]) / step;
	long standartLong = ([standart integerValue] - [min integerValue]) / step;

	self.gasLimitSlider.maximumValue = count;
	self.gasLimitSlider.minimumValue = 0;
	self.gasLimitSlider.value = standartLong;

	self.gasLimitMin = [min integerValue];
	self.gasLimitStep = step;

	self.gasLimitValueLabel.text = [standart stringValue];
	self.gasLimitMinValueLabel.text = [min stringValue];
	self.gasLimitMaxValueLabel.text = [max stringValue];
}

@end
