//
//  TokenFunctionDetailViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
@property (strong,nonatomic) NSDecimalNumber* FEE;
@property (strong,nonatomic) NSDecimalNumber* minFee;
@property (strong,nonatomic) NSDecimalNumber* maxFee;

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

    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewTopOffset, CGRectGetWidth(self.view.frame), self.view.frame.size.height - scrollViewTopOffset)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    for (int i = 0; i < self.function.inputs.count; i++) {
        TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldsViews" owner:self options:nil] lastObject];
        parameter.frame = CGRectMake(10.f, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, CGRectGetWidth(self.view.frame) - 20.f, heighOfElement);
        [parameter.textField setItem:self.function.inputs[i]];
        [parameter.titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Parameter", nil), i + 1]];
        heighOfPrevElement = heighOfElement;
        parameter.textField.inputAccessoryView = [self createToolBarInput];
        parameter.textField.customDelegate = self;
        parameter.tag = i;
        
        [self.scrollView addSubview:parameter];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
    }
    
    if (!self.fromQStore) {
        
        SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderFeeView" owner:self options:nil] lastObject];
        feeView.frame = CGRectMake(0, yoffset * self.function.inputs.count - 1 + heighOfPrevElement * self.function.inputs.count - 1 + yoffsetFirstElement + 50.0f, self.view.frame.size.width, 180);
        feeView.delegate = self;
        self.feeView = feeView;
        [self.scrollView addSubview:feeView];

        UIButton *callButton = [[UIButton alloc] init];
        callButton.frame = CGRectMake((self.view.frame.size.width - 150.0f) / 2.0f, yoffset * self.function.inputs.count - 1 + heighOfPrevElement * self.function.inputs.count - 1 + yoffsetFirstElement + 50.0f + 180, 150, 32.0f);
        [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
        callButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
        [callButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
        [callButton setBackgroundColor:customRedColor()];
        [callButton addTarget:self action:@selector(didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:callButton];
        
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 callButton.frame.origin.y + callButton.frame.size.height + 30.0f);
        
    }
    
    [self.view addSubview:self.scrollView];
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
    [self.delegate didCallFunctionWithItem:self.function andParam:[self prepareInputsData] andToken:self.token andFee:self.FEE];
}

- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark

- (void)okButtonPressed:(PopUpViewController *)sender {
    
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
