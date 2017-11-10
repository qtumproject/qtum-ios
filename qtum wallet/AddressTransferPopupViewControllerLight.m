//
//  AddressTransferPopupViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AddressTransferPopupViewControllerLight.h"

@interface AddressTransferPopupViewControllerLight ()

@end

@implementation AddressTransferPopupViewControllerLight

-(UIPickerView*)createPickerView {
    
    UIPickerView* fromPicker = [[UIPickerView alloc] init];
    fromPicker.backgroundColor = [UIColor whiteColor];
    fromPicker.delegate = self;
    fromPicker.dataSource = self;
    fromPicker.showsSelectionIndicator = YES;
    return fromPicker;
}

- (UIToolbar*)createToolbar {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(endEditing)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    return toolbar;
}

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view {
    
    ContracBalancesObject* addressObject = self.fromAddressesVariants[row];
    NSString* amount = addressObject.longBalanceStringBalance;
    
    UIView* container;
    UILabel* amountLabel;
    UILabel* addressLabel;
    
    if(view == nil) {
        container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, pickerView.frame.size.width * 0.65, 30)];
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.size.width + 10 + 20,
                                                                0,
                                                                pickerView.frame.size.width - addressLabel.frame.size.width - 10 -20,
                                                                30)];

        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = addressObject.addressString;
        addressLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:14];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = lightBlackColor();
        
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.text = amount;
        amountLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor = lightBlackColor();
        
        CGSize size = [amountLabel.text sizeWithAttributes:@{NSFontAttributeName : amountLabel.font}];
        if (size.width > amountLabel.bounds.size.width) {
            amountLabel.text = addressObject.shortBalanceStringBalance;
        }
        
        [container addSubview:amountLabel];
        [container addSubview:addressLabel];
    }
    
    return container;
}

@end
