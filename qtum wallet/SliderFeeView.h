//
//  SliderFeeView.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldWithLine.h"

@protocol SliderFeeViewDelegate

- (void)didChangeFeeSlider:(UISlider *)slider;
- (void)didChangeGasPriceSlider:(NSDecimalNumber *)value;
- (void)didChangeGasLimiteSlider:(NSDecimalNumber *)value;

@end


@interface SliderFeeView : UIView

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *minFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxFeeLabel;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *feeTextField;
@property (weak, nonatomic)  id <SliderFeeViewDelegate> delegate;

- (void)setMinGasPrice:(NSNumber *)min andMax:(NSNumber *)max step:(long)step;
- (void)setMinGasLimit:(NSNumber *)min andMax:(NSNumber *)max standart:(NSNumber *)standart step:(long)step;

@end
