//
//  AddressTransferPopupViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
    toolbar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(endEditing)];
    doneButton.tintColor = lightGreenColor();
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
    
    NSString *text = self.fromAddressesVariants[row];
    
    UILabel *label = (UILabel*)view;
    if(view == nil) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 50, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = text;
        label.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = lightBlackColor();
    }
    
    return label;
}

@end
