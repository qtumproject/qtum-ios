//
//  ConstructorFromAbiViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConstructorFromAbiViewControllerLight.h"
#import "TextFieldParameterView.h"

@interface ConstructorFromAbiViewControllerLight ()

@end

@implementation ConstructorFromAbiViewControllerLight

#pragma mark - Configuration

- (void)confixHeaderFields {

	NSInteger contractNameTraling = 50;

	UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-token-light"]];
	image.tintColor = lightBlackColor ();
	image.frame = CGRectMake (10.0f, 22.0f, image.frame.size.width, image.frame.size.height);
	[self.scrollView addSubview:image];

	UITextField *localContractNameTextField = [[UITextField alloc] init];
	localContractNameTextField.tintColor = [UIColor colorWithRed:54 / 255. green:185 / 255. blue:200 / 255. alpha:0.5];
	localContractNameTextField.text = self.contractTitle;
	localContractNameTextField.textColor = lightBlackColor ();
	localContractNameTextField.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:18];
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
		TextFieldParameterView *parameterView = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldViewsLight" owner:self options:nil] lastObject];
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
	nextButton.frame = CGRectMake ((self.view.frame.size.width - 240.0f) / 2.0f, yoffset * self.formModel.constructorItem.inputs.count - 1 + heighOfPrevElement * self.formModel.constructorItem.inputs.count - 1 + yoffsetFirstElement + 50.0f, 240, 50.0f);
	[nextButton setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
	nextButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
	[nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[nextButton setBackgroundColor:lightGreenColor ()];
	[nextButton addTarget:self action:@selector (didPressedNextAction:) forControlEvents:UIControlEventTouchUpInside];
	nextButton.layer.masksToBounds = YES;
	nextButton.layer.cornerRadius = 5;
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

- (UIToolbar *)createToolBarInput {

	UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake (0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
	toolbar.barStyle = UIBarStyleDefault;
	toolbar.translucent = NO;

	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedCancelAction:)];
	doneButton.tintColor = customBlueColor ();

	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector (didPressedNextOnTextField:)];

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
		self.nextButton.alpha = 0.5;
	}
}


@end
