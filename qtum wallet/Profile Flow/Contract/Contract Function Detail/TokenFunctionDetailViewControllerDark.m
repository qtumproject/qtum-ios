//
//  TokenFunctionDetailViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionDetailViewControllerDark.h"
#import "TextFieldParameterView.h"

@interface TokenFunctionDetailViewControllerDark ()

@end

@implementation TokenFunctionDetailViewControllerDark

- (UIPickerView *)createPickerView {
    
    UIPickerView *fromPicker = [[UIPickerView alloc] init];
    fromPicker.backgroundColor = customBlackColor ();
    fromPicker.delegate = self;
    fromPicker.dataSource = self;
    fromPicker.showsSelectionIndicator = YES;
    return fromPicker;
}

- (UIToolbar *)createToolbar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector (didVoidTapAction:)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    return toolbar;
}

- (CGFloat)pickerView:(UIPickerView *) pickerView rowHeightForComponent:(NSInteger) component {
    
    return 40;
}

- (UIView *)pickerView:(UIPickerView *) pickerView
            viewForRow:(NSInteger) row
          forComponent:(NSInteger) component
           reusingView:(UIView *) view {
    
    ContracBalancesObject *addressObject = (ContracBalancesObject*)self.tokenBalancesInfo[row];
    NSString *amount = addressObject.longBalanceStringBalance;
    
    UIView *container;
    UILabel *amountLabel;
    UILabel *addressLabel;
    
    if (view == nil) {
        container = [[UIView alloc] initWithFrame:CGRectMake (0, 0, pickerView.frame.size.width, 30)];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake (20, 0, pickerView.frame.size.width * 0.65, 30)];
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake (addressLabel.frame.size.width + 10 + 20,
                                                                 0,
                                                                 pickerView.frame.size.width - addressLabel.frame.size.width - 10 - 20,
                                                                 30)];
        
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = addressObject.addressString;
        addressLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:14.0f];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = customBlueColor ();
        
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:15.0f];
        amountLabel.text = amount;
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor = customBlueColor ();
        
        CGSize size = [amountLabel.text sizeWithAttributes:@{NSFontAttributeName: amountLabel.font}];
        if (size.width > amountLabel.bounds.size.width) {
            amountLabel.text = addressObject.shortBalanceStringBalance;
        }
        
        [container addSubview:amountLabel];
        [container addSubview:addressLabel];
    }
    
    return container;
}

- (void)pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component {
    
}

- (TextFieldWithLine*)amountInputView {
    
    TextFieldWithLine *amount = (TextFieldWithLine *)[[[NSBundle mainBundle] loadNibNamed:@"TextFieldWithLineDarkSend" owner:self options:nil] lastObject];
    return amount;
}

- (TextFieldParameterView*)parametersInputView {
    
    TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldsViews" owner:self options:nil] lastObject];
    return parameter;
}

-(SliderFeeView*)feeSliderView {
    
    SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderFeeView" owner:self options:nil] lastObject];
    feeView.delegate = self;
    feeView.feeTextField.delegate = self;
    return feeView;
}

-(UIButton*)callButton {
    
    UIButton *callButton = [[UIButton alloc] init];
    callButton.translatesAutoresizingMaskIntoConstraints = NO;
    [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
    callButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
    [callButton setTitleColor:customBlackColor () forState:UIControlStateNormal];
    [callButton setBackgroundColor:customRedColor ()];
    [callButton addTarget:self action:@selector (didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

@end
