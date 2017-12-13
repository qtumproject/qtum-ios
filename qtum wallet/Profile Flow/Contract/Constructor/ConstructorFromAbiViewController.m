//
//  ConstructorFromAbiViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConstructorFromAbiViewController.h"
#import "TextFieldParameterView.h"

@interface ConstructorFromAbiViewController ()

@property (assign, nonatomic) NSInteger activeTextFieldTag;
@property (assign, nonatomic) BOOL isTextFieldsFilled;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *stepTextLabel;

@end

@implementation ConstructorFromAbiViewController

@synthesize originInsets, scrollView, delegate, formModel, contractTitle;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    [self configLocalization];
	[self configTextFields];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.stepTextLabel.text = NSLocalizedString(@"Step 2 of 2", @"");
    self.titleTextLabel.text = NSLocalizedString(@"Smart Contract Parameters", @"Smart Contract Parameters Contollers Title");
}

- (void)confixHeaderFields {

	NSInteger contractNameTraling = 50;

	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-token_not_empty"]];
	image.frame = CGRectMake (10.0f, 22.0f, image.frame.size.width, image.frame.size.height);
	[self.scrollView addSubview:image];

	UITextField *localContractNameTextField = [[UITextField alloc] init];
	localContractNameTextField.tintColor = customBlueColor ();
	localContractNameTextField.text = self.contractTitle;
	localContractNameTextField.textColor = customBlueColor ();
	localContractNameTextField.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
	[localContractNameTextField sizeToFit];
	localContractNameTextField.frame = CGRectMake (image.frame.origin.x + image.frame.size.width + 5.0f,
			image.frame.origin.y + image.frame.size.height / 2.0f - localContractNameTextField.frame.size.height / 2.0f,
			self.view.frame.size.width - image.frame.origin.x + image.frame.size.width + 5.0f - contractNameTraling,
			localContractNameTextField.frame.size.height);
	self.localContractNameTextField = localContractNameTextField;
	[self.scrollView addSubview:localContractNameTextField];
}

- (void)configTextFields {

	NSInteger yoffset = 0;
	NSInteger yoffsetFirstElement = 30;
	NSInteger heighOfPrevElement = 0;
	NSInteger heighOfElement = 60;
	NSInteger scrollViewTopOffset = 88;
	NSInteger scrollViewBottomInset = 49;


	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake (0, scrollViewTopOffset, CGRectGetWidth (self.view.frame), self.view.frame.size.height - scrollViewTopOffset)];
	self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

	[self confixHeaderFields];

	for (int i = 0; i < self.formModel.constructorItem.inputs.count; i++) {
		TextFieldParameterView *parameterView = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldsViews" owner:self options:nil] lastObject];
		parameterView.frame = CGRectMake (0.0f, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, CGRectGetWidth (self.view.frame), heighOfElement);
		[parameterView.textField setItem:self.formModel.constructorItem.inputs[i]];
		heighOfPrevElement = heighOfElement;
		parameterView.textField.inputAccessoryView = [self createToolBarInput];
		parameterView.textField.customDelegate = self;
		parameterView.tag = i;

		[self.scrollView addSubview:parameterView];
		self.scrollView.contentSize = CGSizeMake (self.view.frame.size.width,
				yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
	}

	UIButton *nextButton = [[UIButton alloc] init];
	nextButton.frame = CGRectMake ((self.view.frame.size.width - 150.0f) / 2.0f, yoffset * self.formModel.constructorItem.inputs.count - 1 + heighOfPrevElement * self.formModel.constructorItem.inputs.count - 1 + yoffsetFirstElement + 50.0f, 150, 32.0f);
	[nextButton setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
	nextButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
	[nextButton setTitleColor:customBlackColor () forState:UIControlStateNormal];
	[nextButton setBackgroundColor:customRedColor ()];
	[nextButton addTarget:self action:@selector (didPressedNextAction:) forControlEvents:UIControlEventTouchUpInside];
	self.nextButton = nextButton;
	[self.scrollView addSubview:nextButton];

	self.scrollView.contentSize = CGSizeMake (self.view.frame.size.width,
			nextButton.frame.origin.y + nextButton.frame.size.height + 30.0f);

	self.scrollView.contentInset =
			self.originInsets = UIEdgeInsetsMake (0, 0, scrollViewBottomInset, 0);
	[self.view addSubview:self.scrollView];
	[self.view sendSubviewToBack:self.scrollView];
	[self updateControls];
}

#pragma mark - Private Methods

- (NSArray<ResultTokenInputsModel *> *)prepareInputsData {

	NSMutableArray *inputsData = @[].mutableCopy;
	for (TextFieldParameterView *parameter in self.scrollView.subviews) {
		if ([parameter isKindOfClass:[TextFieldParameterView class]]) {
			ResultTokenInputsModel *input = [ResultTokenInputsModel new];
			input.name = parameter.textField.item.name;
			input.value = parameter.textField.text ? : @"";
			[inputsData addObject:input];
		}
	}
	return [inputsData copy];
}


- (UIToolbar *)createToolBarInput {

	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.translucent = NO;

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedCancelAction:)];

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedNextOnTextField:)];
	cancelButton.tintColor = customBlueColor ();

	toolbar.items = @[doneButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			cancelButton];
	[toolbar sizeToFit];
	return toolbar;
}

- (void)updateControls {

	BOOL isFilled = [self isTextFieldsFilled];

	if (isFilled) {

		self.nextButton.enabled = YES;
		self.nextButton.alpha = 1;
	} else {

		self.nextButton.enabled = NO;
		self.nextButton.alpha = 0.7;
	}
}

- (BOOL)isTextFieldsFilled {

	BOOL isFilled = YES;
	for (TextFieldParameterView *parameter in self.scrollView.subviews) {
		if ([parameter isKindOfClass:[TextFieldParameterView class]] && parameter.textField.text.length == 0) {
			isFilled = NO;
		}
	}
	return isFilled;
}

#pragma mark - AbiTextFieldWithLineDelegate

- (void)textFieldDidBeginEditing:(UITextField *) textField {
	self.activeTextFieldTag = textField.superview.tag;
}

- (void)textFieldDidEndEditing:(UITextField *) textField {

	[self updateControls];
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id) sender {
	[self.delegate didPressedBack];
}

- (IBAction)didPressedNextOnTextField:(id) sender {

	if (self.activeTextFieldTag < self.formModel.constructorItem.inputs.count - 1) {
		TextFieldParameterView *parameter = [self.scrollView viewWithTag:self.activeTextFieldTag + 1];
		UITextField *texField = parameter.textField;
		[texField becomeFirstResponder];
	} else if ([self isTextFieldsFilled]) {

		[self didPressedNextAction:nil];
		[self didVoidTapAction:nil];
	} else {

		[self didVoidTapAction:nil];
	}
}

- (IBAction)didPressedNextAction:(id) sender {

	[self.delegate createStepOneNextDidPressedWithInputs:[self prepareInputsData] andContractName:self.localContractNameTextField.text];
}

- (IBAction)didVoidTapAction:(id) sender {
	[self.view endEditing:YES];
}

@end
