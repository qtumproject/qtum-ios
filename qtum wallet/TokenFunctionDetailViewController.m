//
//  TokenFunctionDetailViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionDetailViewController.h"
#import "TextFieldParameterView.h"
#import "ResultTokenInputsModel.h"
#import "NSNumber+Comparison.h"
#import "InformationPopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "TransactionManager.h"

@interface TokenFunctionDetailViewController () <AbiTextFieldWithLineDelegate, PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *result;

@property (strong, nonatomic) NSDecimalNumber* FEE;
@property (strong, nonatomic) NSDecimalNumber* gasPrice;
@property (strong, nonatomic) NSDecimalNumber* gasLimit;
@property (strong, nonatomic) NSDecimalNumber* minFee;
@property (strong, nonatomic) NSDecimalNumber* maxFee;

@property (assign, nonatomic) NSInteger activeTextFieldTag;

@end

@implementation TokenFunctionDetailViewController

@synthesize originInsets, scrollView, delegate, function, fromQStore, token;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextFields];
}

#pragma mark - Configuration

-(void)configTextFields {
    
    NSInteger yoffset = 0;
    NSInteger yoffsetFirstElement = 0;
    NSInteger heighOfPrevElement = 0;
    NSInteger heighOfElement = 60;
    NSInteger scrollViewTopOffset = 64;
    NSInteger scrollViewBottomOffset = 49;

    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:scrollViewTopOffset];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraints:@[left, right, top, bottom]];
    
    NSMutableArray *params = [NSMutableArray new];
    for (int i = 0; i < self.function.inputs.count; i++) {
        TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldsViews" owner:self options:nil] lastObject];
        [params addObject:parameter];
        parameter.translatesAutoresizingMaskIntoConstraints = NO;
        [parameter.textField setItem:self.function.inputs[i]];
        [parameter.titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Parameter", nil), i + 1]];
        parameter.textField.inputAccessoryView = [self createToolBarInput];
        parameter.textField.customDelegate = self;
        parameter.tag = i;
        
        [self.scrollView addSubview:parameter];
        
        UIView *topItem;
        UIView *bottomItem;
        if (i == 0) {
            topItem = self.scrollView;
        } else {
            topItem = [params objectAtIndex:i - 1];
            if (i == self.function.inputs.count - 1 && self.fromQStore) {
                bottomItem = self.scrollView;
            }
        }
        
        if (i == 0) {
            NSLayoutConstraint *center = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            [self.scrollView addConstraint:center];
        }
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f];
        
        [self.scrollView addConstraint:left];
        [self.scrollView addConstraint:right];
        
        if (bottomItem) {
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomItem attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            [self.scrollView addConstraint:bottom];
        }
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topItem attribute:(i == 0) ? NSLayoutAttributeTop : NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        [self.scrollView addConstraint:top];
    }
    
    if (!self.fromQStore) {
        SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderFeeView" owner:self options:nil] lastObject];
        feeView.translatesAutoresizingMaskIntoConstraints = NO;
        feeView.delegate = self;
        feeView.feeTextField.delegate = self;
        self.feeView = feeView;
        [self.scrollView addSubview:feeView];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20.0f];
        
        if (params.count == 0) {
            NSLayoutConstraint *center = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:30.0f];
            
            [self.scrollView addConstraint:center];
            [self.scrollView addConstraint:top];
        } else {
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[params lastObject] attribute:NSLayoutAttributeBottom multiplier:1.0f constant:30.0f];
            
            [self.scrollView addConstraint:top];
        }
        
        [self.scrollView addConstraints:@[left, right]];
        
        UIButton *callButton = [[UIButton alloc] init];
        callButton.translatesAutoresizingMaskIntoConstraints = NO;
        [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
        callButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
        [callButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
        [callButton setBackgroundColor:customRedColor()];
        [callButton addTarget:self action:@selector(didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:callButton];
        
        NSLayoutConstraint *topButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:feeView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:30.0f];
        NSLayoutConstraint *bottomButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.0f];
        NSLayoutConstraint *centerButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:150.0f];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:32.0f];
        
        [callButton addConstraint:width];
        [callButton addConstraint:height];
        [self.scrollView addConstraints:@[topButton, bottomButton, centerButton]];
    }
    
    self.scrollView.contentInset =
    self.originInsets = UIEdgeInsetsMake(0, 0, scrollViewBottomOffset, 0);
}


- (UIToolbar*)createToolBarInput {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector(didPressedCancelAction:)];
    doneButton.tintColor = customBlueColor();
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector(didPressedNextOnTextField:)];
    cancelButton.tintColor = customBlueColor();
    
    toolbar.items = @[doneButton,
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      cancelButton];
    [toolbar sizeToFit];
    return toolbar;
}

#pragma mark - Private Methods

-(NSArray<ResultTokenInputsModel*>*)prepareInputsData {
    
    NSMutableArray* inputsData = @[].mutableCopy;
    for (TextFieldParameterView* parameter in self.scrollView.subviews) {
        if ([parameter isKindOfClass:[TextFieldParameterView class]]) {
            ResultTokenInputsModel* input = [ResultTokenInputsModel new];
            input.name = parameter.textField.item.name;
            input.value = parameter.textField.text;
            [inputsData addObject:input];
        }
    }
    return [inputsData copy];
}



#pragma mark - AbiTextFieldWithLineDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextFieldTag = textField.superview.tag;
}

#pragma mark - Public Methods 

-(void)showResultViewWithOutputs:(NSArray*) outputs {
    
    [[PopUpsManager sharedInstance] dismissLoader];
    
    NSMutableString* result = [NSMutableString new];
    for (id output in outputs) {
        [result appendFormat:@"%@",output];
    }
    
    self.result.text = result.length > 0 ? result : NSLocalizedString(@"There is no output", nil);
    self.result.hidden = NO;
    self.scrollView.hidden = YES;
    self.callButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

-(void)showLoader {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
}

-(void)hideLoader {
    [[PopUpsManager sharedInstance] dismissLoader];
}

- (void)showCompletedPopUp {
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *)message {
    
    PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
    if (message) {
        content.messageString = message;
        content.titleString = NSLocalizedString(@"Failed", nil);
    }
    
    ErrorPopUpViewController *popUp = [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
    [popUp setOnlyCancelButton];
}

- (void)setMinFee:(NSNumber*) minFee andMaxFee:(NSNumber*) maxFee {
    
    self.feeView.slider.maximumValue = maxFee.floatValue;
    self.feeView.slider.minimumValue = minFee.floatValue;
    self.feeView.slider.value = 0.1f;
    self.FEE = [NSDecimalNumber decimalNumberWithString:@"0.1"];
    
    self.feeView.minFeeLabel.text = [NSString stringWithFormat:@"%@", minFee];
    self.feeView.maxFeeLabel.text = [NSString stringWithFormat:@"%@", maxFee];
    
    self.feeView.feeTextField.text = [NSString stringWithFormat:@"%@", self.FEE];
    
    self.maxFee = [maxFee decimalNumber];
    self.minFee = [minFee decimalNumber];
}

- (void)setMinGasPrice:(NSNumber *)min andMax:(NSNumber *)max step:(long)step {
    [self.feeView setMinGasPrice:min andMax:max step:step];
    
    self.gasPrice = [[NSDecimalNumber alloc] initWithFloat:min.floatValue];
}

- (void)setMinGasLimit:(NSNumber *)min andMax:(NSNumber *)max standart:(NSNumber *)standart step:(long)step {
    [self.feeView setMinGasLimit:min andMax:max standart:standart step:step];
    
    self.gasLimit = [[NSDecimalNumber alloc] initWithFloat:standart.floatValue];
}

- (void)showNotEnoughFeeAlertWithEstimatedFee:(NSDecimalNumber*) estimatedFee {
    
    NSString* errorString = [NSString stringWithFormat:@"Insufficient fee. Please use minimum of %@ QTUM", estimatedFee];
    [self showErrorPopUp:NSLocalizedString(errorString, nil)];
}

#pragma mark - SliderFeeViewDelegate

- (void)didChangeFeeSlider:(UISlider*) slider {
    
    NSDecimalNumber* sliderValue = [[NSDecimalNumber alloc] initWithFloat:slider.value];
    self.FEE = sliderValue;
    self.feeView.feeTextField.text = [[NSString stringWithFormat:@"%@", self.FEE] stringByReplacingOccurrencesOfString:@"." withString:@","];
}

- (void)didChangeGasLimiteSlider:(NSDecimalNumber *)value {
    self.gasLimit = value;
}

- (void)didChangeGasPriceSlider:(NSDecimalNumber *)value {
    self.gasPrice = value;
}

#pragma mark - TextFeild delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.feeView.feeTextField) {
        if ([string isEqualToString:@","] || [string isEqualToString:@"."]) {
            return ![textField.text containsString:string] && !(textField.text.length == 0);
        } else {
            NSString* feeValueString = [[textField.text stringByAppendingString:string] stringByReplacingOccurrencesOfString:@"," withString:@"."];
            NSDecimalNumber *feeValue = [NSDecimalNumber decimalNumberWithString:feeValueString];
            
            [self.feeView.slider setValue:feeValue.floatValue animated:YES];
        }
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.feeView.feeTextField) {
        [self normalizeFee];
    }
}

-(void)normalizeFee {
    NSString* feeValueString = [self.feeView.feeTextField.text stringByReplacingOccurrencesOfString:@"," withString:@"."];
    NSDecimalNumber *feeValue = [NSDecimalNumber decimalNumberWithString:feeValueString];
    
    if ([feeValue isGreaterThan:self.maxFee] ) {
        
        self.feeView.feeTextField.text = [NSString stringWithFormat:@"%@", self.maxFee];;
        self.FEE = self.maxFee;
        
    } else if ([feeValue isLessThan:self.minFee]) {
        
        self.feeView.feeTextField.text = [NSString stringWithFormat:@"%@", self.minFee];
        self.FEE = self.minFee;
    } else {
        
        self.FEE = feeValue;
    }
}

#pragma mark - Actions

- (IBAction)didPressedNextOnTextField:(id)sender {
    if (self.activeTextFieldTag < self.function.inputs.count - 1) {
        TextFieldParameterView *parameter = [self.scrollView viewWithTag:self.activeTextFieldTag + 1];
        UITextField* texField = parameter.textField;
        [texField becomeFirstResponder];
    } else {
        [self didPressedCallAction:nil];
        [self didVoidTapAction:nil];
    }
}

- (IBAction)didPressedCancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedCallAction:(id)sender {
    [self didVoidTapAction:nil];
    [self normalizeFee];
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    [self.delegate didCallFunctionWithItem:self.function andParam:[self prepareInputsData] andToken:self.token andFee:self.FEE andGasPrice:self.gasPrice andGasLimit:self.gasLimit];
}

- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
