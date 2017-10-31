//
//  AddressTransferPopupViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AddressTransferPopupViewController.h"
#import "TextFieldWithLine.h"
#import "NSString+Extension.h"


@interface AddressTransferPopupViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *amountTextFieldView;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *toTextFieldVIew;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *fromTextFieldView;
@property (weak, nonatomic) IBOutlet UIButton *transferButton;

@end

@implementation AddressTransferPopupViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configToAddressView];
    [self configFromAddressesView];
    [self configAmountView];
    [self updateControls];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configuration

-(void)configToAddressView {
    
    self.toTextFieldVIew.text = self.toAddress;
    self.toTextFieldVIew.enabled = NO;
    self.toTextFieldVIew.delegate = self;
}

-(void)configFromAddressesView {
    
    self.fromTextFieldView.inputView = [self createPickerView];
    self.fromTextFieldView.inputAccessoryView = [self createToolbar];
    self.fromTextFieldView.delegate = self;
}

-(void)configAmountView {
    
    self.amountTextFieldView.inputAccessoryView = [self createToolbar];
    self.amountTextFieldView.delegate = self;
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
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(endEditing)];
    toolbar.items = @[
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      doneButton];
    [toolbar sizeToFit];
    
    return toolbar;
}

#pragma mark -

-(BOOL)isFilled {
    return (self.amountTextFieldView.text.length > 0) && (self.fromTextFieldView.text.length > 0);
}

-(void)updateControls {
    
    BOOL isFilled = [self isFilled];
    
    self.transferButton.alpha = isFilled ? 1 : 0.5;
    self.transferButton.enabled = isFilled;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([AppSettings sharedInstance].isDarkTheme && textField == self.fromTextFieldView) {
        textField.inputView.backgroundColor = customBlackColor();
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (!textField.text.length && [self.fromTextFieldView isEqual:textField]) {
        self.fromTextFieldView.text = self.fromAddressesVariants.allKeys[0];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.amountTextFieldView]) {
        self.amount = textField.text;
    } else if([textField isEqual:self.fromTextFieldView]) {
        self.fromAddress = textField.text;
    }
    
    [self updateControls];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.amountTextFieldView]) {

        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        BOOL isDecimal = newString.isDecimalString;
        
        return isDecimal;
    }

    return YES;
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

//- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    NSString* fromAddress = self.fromAddressesVariants[row];
//    self.fromAddress = fromAddress;
//    return fromAddress;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.fromAddress =
    self.fromTextFieldView.text = self.fromAddressesVariants.allKeys[row];
    [self updateControls];
}

-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view {
    
    NSString* address = self.fromAddressesVariants.allKeys[row];
    NSString* amount = self.fromAddressesVariants[address][@"longString"];
    
    UIView* container;
    UILabel* amountLabel;
    UILabel* addressLabel;
    
    if(view == nil) {
        container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, pickerView.frame.size.width * 0.65, 30)];
        amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.size.width + 10 + 20,
                                                                0,
                                                                pickerView.frame.size.width - addressLabel.frame.size.width - 10 - 20,
                                                                30)];
        
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = address;
        addressLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:14.0f];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.textColor = customBlueColor();
        
        amountLabel.backgroundColor = [UIColor clearColor];
        amountLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:15.0f];
        amountLabel.text = amount;
        amountLabel.textAlignment = NSTextAlignmentCenter;
        amountLabel.textColor = customBlueColor();
        
        CGSize size = [amountLabel.text sizeWithAttributes:@{NSFontAttributeName : amountLabel.font}];
        if (size.width > amountLabel.bounds.size.width) {
            amountLabel.text = self.fromAddressesVariants[address][@"shortString"];;
        }
        
        [container addSubview:amountLabel];
        [container addSubview:addressLabel];
    }
    
    return container;
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
