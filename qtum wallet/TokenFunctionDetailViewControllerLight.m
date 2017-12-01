//
//  TokenFunctionDetailViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionDetailViewControllerLight.h"
#import "TextFieldParameterView.h"
#import "Masonry.h"
#import "QueryFunctionView.h"

@interface TokenFunctionDetailViewControllerLight () <AbiTextFieldWithLineDelegate>

@end

static NSInteger callButtonTopOffset = 40;
static NSInteger callButtonViewBottomOffset = 20;

@implementation TokenFunctionDetailViewControllerLight

#pragma mark - Configuration

- (UIPickerView *)createPickerView {
    
    UIPickerView *fromPicker = [[UIPickerView alloc] init];
    fromPicker.backgroundColor = [UIColor whiteColor];
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
        addressLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = lightBlackColor ();
        
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.text = amount;
        amountLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor = lightBlackColor ();
        
        CGSize size = [amountLabel.text sizeWithAttributes:@{NSFontAttributeName: amountLabel.font}];
        if (size.width > amountLabel.bounds.size.width) {
            amountLabel.text = addressObject.shortBalanceStringBalance;
        }
        
        [container addSubview:amountLabel];
        [container addSubview:addressLabel];
    }
    
    return container;
}

- (TextFieldWithLine*)amountInputView {
    
    TextFieldWithLine *amount = (TextFieldWithLine *)[[[NSBundle mainBundle] loadNibNamed:@"TextFieldWithLineLightSend" owner:self options:nil] lastObject];
    return amount;
}

- (TextFieldParameterView*)parametersInputView {
    
    TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldViewsLight" owner:self options:nil] lastObject];
    return parameter;
}

-(SliderFeeView*)feeSliderView {
    
    SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderViewLight" owner:self options:nil] lastObject];
    feeView.delegate = self;
    feeView.feeTextField.delegate = self;
    return feeView;
}

-(UIButton*)callButton {
    
    UIButton *callButton = [[UIButton alloc] init];
    [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
    callButton.layer.cornerRadius = 5;
    callButton.layer.masksToBounds = YES;
    callButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton setBackgroundColor:lightGreenColor ()];
    [callButton addTarget:self action:@selector (didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

- (UIToolbar *)createToolBarInput {
	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.translucent = NO;

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedCancelAction:)];
	doneButton.tintColor = lightGreenColor ();

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedNextOnTextField:)];
	cancelButton.tintColor = customBlueColor ();

	toolbar.items = @[doneButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			cancelButton];
	[toolbar sizeToFit];
	return toolbar;
}

-(QueryFunctionView*)queryView {
    
    QueryFunctionView *queryView = (QueryFunctionView *)[[[NSBundle mainBundle] loadNibNamed:@"QueryFunctionViewLight" owner:self options:nil] lastObject];
    return queryView;
}

-(void)makeConstraintForCallButton {
    
    if (!self.lastViewInScroll) {
        
        self.lastViewInScroll = self.scrollView;
    } else {
        
        [self.lastViewInScrollBottomOffset uninstall];
    }
    
    UIButton *callButton = [self callButton];
    [self.scrollView addSubview:callButton];
    
    [callButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lastViewInScroll.bottom).with.offset(callButtonTopOffset);
        make.size.equalTo(@(CGSizeMake(230, 50)));
        make.centerX.equalTo(callButton.superview).priorityMedium();
        self.lastViewInScrollBottomOffset = make.bottom.equalTo(callButton.superview.bottom).with.offset(-callButtonViewBottomOffset);
    }];
    
    self.lastViewInScroll = callButton;
}


@end
