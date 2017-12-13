//
//  TokenFunctionDetailViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionDetailViewController.h"
#import "TextFieldParameterView.h"
#import "ErrorPopUpViewController.h"
#import "Masonry.h"
#import "QueryFunctionView.h"

@interface TokenFunctionDetailViewController () <AbiTextFieldWithLineDelegate, PopUpViewControllerDelegate, PopUpWithTwoButtonsViewControllerDelegate, QueryFunctionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *result;
@property (weak, nonatomic) IBOutlet UIButton *functionActionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (strong, nonatomic) QTUMBigNumber *FEE;
@property (strong, nonatomic) QTUMBigNumber *gasPrice;
@property (strong, nonatomic) QTUMBigNumber *gasLimit;
@property (strong, nonatomic) QTUMBigNumber *minFee;
@property (strong, nonatomic) QTUMBigNumber *maxFee;

@property (assign, nonatomic) NSInteger activeTextFieldTag;
@property (weak, nonatomic) QueryFunctionView *queryFunctionView;

- (TextFieldWithLine*)amountInputView;
- (TextFieldParameterView*)parametersInputView;

@end

@implementation TokenFunctionDetailViewController

@synthesize originInsets, scrollView, delegate, function, fromQStore, token, tokenBalancesInfo = _tokenBalancesInfo;

static NSInteger scrollViewTopOffset = 64;
static NSInteger scrollViewBottomOffset = 0;
static NSInteger scrollViewLeading = 0;
static NSInteger scrollViewTrailing = 0;

static NSInteger amountViewTopOffset = 10;
static NSInteger amountViewBottomOffset = 10;
static NSInteger amountViewLeading = 14;
static NSInteger amountViewTrailing = 14;

static NSInteger parameterViewTopOffset = 10;
static NSInteger parameterViewBottomOffset = 10;
static NSInteger parameterViewLeading = 0;
static NSInteger parameterViewTrailing = 0;

static NSInteger feeSliderTopOffset = 40;
static NSInteger feeSliderViewBottomOffset = 0;
static NSInteger feeSliderViewLeading = 0;
static NSInteger feeSliderViewTrailing = 0;

static NSInteger callButtonTopOffset = 20;
static NSInteger callButtonViewBottomOffset = 20;

static NSInteger queryViewTopOffset = 20;
static NSInteger queryViewBottomOffset = 0;
static NSInteger queryViewLeading = 14;
static NSInteger queryViewTrailing = 14;
static NSInteger queryViewheight = 100;


- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    [self configLocalization];
    [self buildView];
    [self updateControls];
}

#pragma mark - Config view

- (void)buildView {
    [self makeConstraintForScrollView];
    
    if (self.function.payable) {
        
        [self makeConstraintForAmountInput];
    }
    
    if (self.function.inputs.count > 0) {
        [self makeConstraintForParameterInputs];
    }
    
    if (!self.fromQStore && !self.function.constant) {
        [self makeConstraintForSettingsView];
        [self makeConstraintForCallButton];
        [self configFromAddressView];
    } else if (self.function.constant) {
        [self makeConstraintForQueryView];
    }
}


-(void)makeConstraintForScrollView {
    
    self.scrollView = [UIScrollView new];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(scrollViewTopOffset, scrollViewLeading, scrollViewBottomOffset, scrollViewTrailing);

    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView.superview).with.insets(padding);
    }];
}

-(void)makeConstraintForAmountInput {
    
    TextFieldWithLine *amount = [self amountInputView];
    amount.delegate = self;
    [self.scrollView addSubview:amount];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(amountViewTopOffset, amountViewLeading, amountViewBottomOffset, amountViewTrailing);
    
    [amount makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amount.superview.top).with.offset(padding.top);
        make.left.equalTo(amount.superview.left).with.offset(padding.left);
        make.centerX.equalTo(amount.superview).priorityMedium();
        self.lastViewInScrollBottomOffset = make.bottom.equalTo(amount.superview.bottom).with.offset(padding.bottom);
        make.right.equalTo(amount.superview.right).with.offset(padding.right);
    }];
    
    self.amountTextField = amount;
    self.lastViewInScroll = amount;
}

-(void)makeConstraintForParameterInputs {
    
    if (!self.lastViewInScroll) {
        
        self.lastViewInScroll = self.scrollView;
    } else {
        
        [self.lastViewInScrollBottomOffset uninstall];
    }
    NSMutableArray *params = [NSMutableArray new];

    UIEdgeInsets padding = UIEdgeInsetsMake(parameterViewTopOffset, parameterViewLeading, parameterViewBottomOffset, parameterViewTrailing);
    
    for (int i = 0; i < self.function.inputs.count; i++) {
        
        TextFieldParameterView *parameter = [self parametersInputView];
        [params addObject:parameter];
        [parameter.textField setItem:self.function.inputs[i]];
        [parameter.titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Parameter", nil), i + 1]];
        parameter.textField.inputAccessoryView = [self createToolBarInput];
        parameter.textField.customDelegate = self;
        parameter.tag = i;
        
        [self.scrollView addSubview:parameter];
        
        UIView *topItem;
        
        if (i == 0) {
            topItem = self.lastViewInScroll;
            
            [parameter makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(topItem.top).with.offset(padding.top);
            }];
            
        } else {
            topItem =  [params objectAtIndex:i - 1];
            
            [parameter makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(topItem.bottom).with.offset(padding.top);
            }];
        }
        
        [parameter makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(parameter.superview).priorityHigh();
            make.left.equalTo(parameter.superview.left).with.offset(padding.left);
            make.right.equalTo(parameter.superview.right).with.offset(-padding.right);
        }];
        
        if (i == self.function.inputs.count - 1) {

            [parameter makeConstraints:^(MASConstraintMaker *make) {

                self.lastViewInScrollBottomOffset = make.bottom.equalTo(parameter.superview.bottom).with.offset(-padding.bottom);
            }];

            self.lastViewInScroll = parameter;
        }
    }
}

-(void)makeConstraintForSettingsView {
    
    if (!self.lastViewInScroll) {
        
        self.lastViewInScroll = self.scrollView;
    } else {
        
        [self.lastViewInScrollBottomOffset uninstall];
    }
    
    
    SliderFeeView *feeView = [self feeSliderView];
    self.feeView = feeView;
    [self.scrollView addSubview:feeView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(feeSliderTopOffset, feeSliderViewTrailing, feeSliderViewBottomOffset, feeSliderViewLeading);

    [feeView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lastViewInScroll.bottom).with.offset(padding.top);
        make.left.equalTo(feeView.superview).with.offset(padding.left);
        make.right.equalTo(feeView.superview).with.offset(-padding.right);
        self.lastViewInScrollBottomOffset = make.bottom.equalTo(feeView.superview.bottom).with.offset(-padding.bottom);
    }];
    
    self.lastViewInScroll = feeView;
}

-(void)makeConstraintForCallButton {
    
    if (!self.lastViewInScroll) {
        
        self.lastViewInScroll = self.scrollView;
    } else {
        
        [self.lastViewInScrollBottomOffset uninstall];
    }

    UIButton *callButton = [self callButton];
    self.functionActionButton = callButton;
    [self.scrollView addSubview:callButton];
    
    [callButton makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lastViewInScroll.bottom).with.offset(callButtonTopOffset);
        make.size.equalTo(@(CGSizeMake(150, 33)));
        make.centerX.equalTo(callButton.superview).priorityMedium();
        self.lastViewInScrollBottomOffset = make.bottom.equalTo(callButton.superview.bottom).with.offset(-callButtonViewBottomOffset);
    }];
    
    self.lastViewInScroll = callButton;
}

-(void)makeConstraintForQueryView {
    
    if (!self.lastViewInScroll) {
        
        self.lastViewInScroll = self.scrollView;
    } else {
        
        [self.lastViewInScrollBottomOffset uninstall];
    }
    
    QueryFunctionView *queryView = [self queryView];
    self.functionActionButton = queryView.queryButton;
    queryView.delegate = self;
    self.queryFunctionView = queryView;
    [self.scrollView addSubview:queryView];
    
    [queryView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lastViewInScroll.bottom).with.offset(queryViewTopOffset);
        make.left.equalTo(queryView.superview.left).with.offset(queryViewLeading);
        make.right.equalTo(queryView.superview.right).with.offset(-queryViewTrailing);
        make.height.equalTo(@(queryViewheight));
        self.lastViewInScrollBottomOffset = make.bottom.equalTo(queryView.superview.bottom).with.offset(-queryViewBottomOffset);
    }];
    
    self.lastViewInScroll = queryView;
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
    [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
    callButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
    [callButton setTitleColor:customBlackColor () forState:UIControlStateNormal];
    [callButton setBackgroundColor:customRedColor ()];
    [callButton addTarget:self action:@selector (didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
    return callButton;
}

-(QueryFunctionView*)queryView {
    
    QueryFunctionView *queryView = (QueryFunctionView *)[[[NSBundle mainBundle] loadNibNamed:@"QueryFunctionViewDark" owner:self options:nil] lastObject];
    return queryView;
}


#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Function Detail", @"Function Detail Controllers Title");
}

- (void)configFromAddressView {
    
    self.feeView.defaultAddressTextField.inputView = [self createPickerView];
    self.feeView.defaultAddressTextField.inputAccessoryView = [self createToolbar];
    self.feeView.defaultAddressTextField.delegate = self;
    if (self.tokenBalancesInfo.count > 0) {
        self.feeView.defaultAddressTextField.text =
        self.feeView.defaultAddressLabel.text =
        self.tokenBalancesInfo[0].addressString;
    }
}

- (UIPickerView *)createPickerView {
    
    UIPickerView *fromPicker = [[UIPickerView alloc] init];
    return fromPicker;
}

- (UIToolbar *)createToolbar {
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    return toolbar;
}

- (void)pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component {
    
    self.feeView.defaultAddressTextField.text =
    self.feeView.defaultAddressLabel.text = 
    self.tokenBalancesInfo[row].addressString;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *) pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
    
    return self.tokenBalancesInfo.count;
}

- (UIToolbar *)createToolBarInput {

	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.translucent = NO;

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedCancelAction:)];
	doneButton.tintColor = customBlueColor ();

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedNextOnTextField:)];
	cancelButton.tintColor = customBlueColor ();

	toolbar.items = @[doneButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			cancelButton];
	[toolbar sizeToFit];
	return toolbar;
}

#pragma mark - Private Methods

- (void)updateControls {
    
    BOOL isValidInputs = [self isValidInputs];
    
    if (isValidInputs) {
        self.functionActionButton.alpha = 1;
        self.functionActionButton.enabled = YES;
    } else {
        self.functionActionButton.alpha = 0.7;
        self.functionActionButton.enabled = NO;
    }
}

- (BOOL)isValidInputs {
    
    BOOL isValidInputs = YES;
    
    for (TextFieldParameterView *parameter in self.scrollView.subviews) {
        if ([parameter isKindOfClass:[TextFieldParameterView class]] && ![parameter isValidParameter]) {
            isValidInputs = NO;
        }
    }
    return isValidInputs;
}

- (NSArray<ResultTokenInputsModel *> *)prepareInputsData {

	NSMutableArray *inputsData = @[].mutableCopy;
	for (TextFieldParameterView *parameter in self.scrollView.subviews) {
		if ([parameter isKindOfClass:[TextFieldParameterView class]]) {
			ResultTokenInputsModel *input = [ResultTokenInputsModel new];
			input.name = parameter.textField.item.name ? : @"";
			input.value = parameter.textField.text ? : @"";
			[inputsData addObject:input];
		}
	}
	return [inputsData copy];
}


#pragma mark - AbiTextFieldWithLineDelegate

- (void)textFieldDidBeginEditing:(UITextField *) textField {
	self.activeTextFieldTag = textField.superview.tag;
}

#pragma mark - Public Methods

- (void)setQueryResult:(NSString *) result {
    
    [self.queryFunctionView setResult:result];
}

- (void)showLoader {
	[SLocator.popupService showLoaderPopUp];
}

- (void)hideLoader {
	[SLocator.popupService dismissLoader];
}

- (void)showCompletedPopUp {
	[SLocator.popupService showInformationPopUp:self withContent:[PopUpContentGenerator contentForSend] presenter:nil completion:nil];
}

- (void)showErrorPopUp:(NSString *) message {

	PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
	if (message) {
		content.messageString = message;
		content.titleString = NSLocalizedString(@"Failed", nil);
	}

	ErrorPopUpViewController *popUp = [SLocator.popupService showErrorPopUp:self withContent:content presenter:nil completion:nil];
	[popUp setOnlyCancelButton];
}

- (void)setMinFee:(QTUMBigNumber *) minFee andMaxFee:(QTUMBigNumber *) maxFee {

	self.feeView.slider.maximumValue = [maxFee decimalNumber].floatValue;
	self.feeView.slider.minimumValue = [minFee decimalNumber].floatValue;
	self.feeView.slider.value = 0.1f;
	self.FEE = [QTUMBigNumber decimalWithString:@"0.1"];

	self.feeView.minFeeLabel.text = minFee.stringValue;
	self.feeView.maxFeeLabel.text = maxFee.stringValue;

	self.feeView.feeTextField.text = self.FEE.stringValue;

	self.maxFee = maxFee;
	self.minFee = minFee;
}

- (void)setMinGasPrice:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max step:(long) step {

	[self.feeView setMinGasPrice:min andMax:max step:step];

	self.gasPrice = [QTUMBigNumber decimalWithString:min.stringValue];
}

- (void)setMinGasLimit:(QTUMBigNumber *) min andMax:(QTUMBigNumber *) max standart:(QTUMBigNumber *) standart step:(long) step {

	[self.feeView setMinGasLimit:min andMax:max standart:standart step:step];

	self.gasLimit = [QTUMBigNumber decimalWithString:standart.stringValue];
}

- (void)showNotEnoughFeeAlertWithEstimatedFee:(NSDecimalNumber *) estimatedFee {

	NSString *errorString = [NSString stringWithFormat:@"Insufficient fee. Please use minimum of %@ QTUM", estimatedFee];
	[self showErrorPopUp:NSLocalizedString(errorString, nil)];
}


#pragma mark - QueryFunctionViewDelegate

- (void)didQueryButtonPressed {
    
    [self.delegate didQueryFunctionWithItem:self.function andParam:[self prepareInputsData] andToken:self.token];
}

#pragma mark - SliderFeeViewDelegate

- (void)didChangeFeeSlider:(UISlider *) slider {

	NSDecimalNumber *sliderValue = [[NSDecimalNumber alloc] initWithFloat:slider.value];
	QTUMBigNumber *bigNumber = [QTUMBigNumber decimalWithString:sliderValue.stringValue];
	self.FEE = bigNumber;
	self.feeView.feeTextField.text = self.FEE.stringValue;
}

- (void)didChangeGasLimiteSlider:(QTUMBigNumber *) value {
	self.gasLimit = value;
}

- (void)didChangeGasPriceSlider:(QTUMBigNumber *) value {
	self.gasPrice = value;
}

#pragma mark - AbiTextFieldWithLineDelegate

-(void)textDidChange {
    
    if (self.queryFunctionView) {
        [self.queryFunctionView changeStateToNormal];
    }
}

#pragma mark - TextFeild delegate

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string {
    
    NSString* resultString = [textField.text stringByAppendingString:string];
    BOOL isValid = YES;

	if (textField == self.feeView.feeTextField) {
        
        isValid = [SLocator.validationInputService isValidAmountString:resultString];
        
        if (isValid) {
            
            QTUMBigNumber *feeValue = [QTUMBigNumber decimalWithString:textField.text];
            [self.feeView.slider setValue:[feeValue decimalNumber].floatValue animated:YES];
        }
    } else if ([textField isEqual:self.amountTextField]){
        isValid = [SLocator.validationInputService isValidAmountString:resultString];
    }

	return isValid;
}

- (void)textFieldDidEndEditing:(UITextField *) textField {
    
	if (textField == self.feeView.feeTextField) {
		[self normalizeFee];
	}
    
    [self updateControls];
}

- (void)normalizeFee {

	QTUMBigNumber *feeValue = [QTUMBigNumber decimalWithString:self.feeView.feeTextField.text];

	if ([feeValue isGreaterThan:self.maxFee]) {

		self.feeView.feeTextField.text = [NSString stringWithFormat:@"%@", self.maxFee.stringValue];;
		self.FEE = self.maxFee;

	} else if ([feeValue isLessThan:self.minFee]) {

		self.feeView.feeTextField.text = [NSString stringWithFormat:@"%@", self.minFee.stringValue];
		self.FEE = self.minFee;
	} else {

		self.FEE = feeValue;
	}
}

#pragma mark - Actions

- (IBAction)didPressedNextOnTextField:(id) sender {
    
	if (self.activeTextFieldTag < self.function.inputs.count - 1) {
		TextFieldParameterView *parameter = [self.scrollView viewWithTag:self.activeTextFieldTag + 1];
		UITextField *texField = parameter.textField;
		[texField becomeFirstResponder];
	} else {
		[self didVoidTapAction:nil];
	}
}

- (IBAction)didPressedCancelAction:(id) sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedCallAction:(id) sender {

	[self didVoidTapAction:nil];
	[self normalizeFee];
    
    QTUMBigNumber* amount;
    if (self.amountTextField.text.length > 0) {
        amount = [QTUMBigNumber decimalWithString:self.amountTextField.text];
    } else {
        amount = [QTUMBigNumber decimalWithInteger:0];
    }
    
	[self.delegate didCallFunctionWithItem:self.function
                                  andParam:[self prepareInputsData]
                                 andAmount:amount
                               fromAddress:self.feeView.defaultAddressTextField.text
                                  andToken:self.token
                                    andFee:self.FEE
                               andGasPrice:self.gasPrice
                               andGasLimit:self.gasLimit];
}


- (IBAction)didVoidTapAction:(id) sender {
	[self.view endEditing:YES];
}

#pragma mark

- (void)okButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

@end
