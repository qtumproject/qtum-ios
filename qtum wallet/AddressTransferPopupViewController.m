//
//  AddressTransferPopupViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressTransferPopupViewController.h"
#import "TextFieldWithLine.h"

@interface AddressTransferPopupViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextFieldView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *toTextFieldVIew;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *fromTextFieldView;

@end

@implementation AddressTransferPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configToAddressView];
    [self configFromAddressesView];
    [self configAmountView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Configuration

-(void)configToAddressView {
    
    self.toTextFieldVIew.text = self.toAddress;
    self.toTextFieldVIew.enabled = NO;
}

-(void)configFromAddressesView {
    
    self.fromTextFieldView.inputView = [self createPickerView];
    self.fromTextFieldView.inputAccessoryView = [self createToolbar];
}

-(void)configAmountView {
    
    self.amountTextFieldView.inputAccessoryView = [self createToolbar];
}

-(UIPickerView*)createPickerView {
    
    UIPickerView* fromPicker = [[UIPickerView alloc] init];
    fromPicker.backgroundColor = customBlackColor();
    fromPicker.delegate = self;
    fromPicker.dataSource = self;
    fromPicker.showsSelectionIndicator = YES;
    return fromPicker;
}

- (UIToolbar*)createToolbar {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    toolbar.barTintColor = customBlackColor();
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(endEditing)];
    doneButton.tintColor = customBlueColor();
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    return toolbar;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.fromAddressesVariants.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString* fromAddress = self.fromAddressesVariants[row];
    self.fromAddress = fromAddress;
    return fromAddress;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.fromTextFieldView.text = self.fromAddressesVariants[row];
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
        label.font = [UIFont fontWithName:@"simplonmono-regular" size:15.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = customBlueColor();
    }
    
    return label;
}

#pragma mark - Actions

- (IBAction)didPressCancelAction:(id)sender {
    [self.delegate cancelButtonPressed:self];
}

- (IBAction)didPressTransferAction:(id)sender {
    [self.delegate okButtonPressed:self];
}

- (void)endEditing {
    [self.view endEditing:YES];
}

@end
