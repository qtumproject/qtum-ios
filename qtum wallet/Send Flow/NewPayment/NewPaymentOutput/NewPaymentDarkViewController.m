//
//  NewPaymentDarkViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewPaymentDarkViewController.h"

@interface NewPaymentDarkViewController ()

@end

@implementation NewPaymentDarkViewController

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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector (actionVoidTap:)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    return toolbar;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    
    return self.tokenBalancesInfo.count;
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

@end
