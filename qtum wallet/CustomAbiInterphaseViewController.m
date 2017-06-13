//
//  CustomAbiInterphaseViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CustomAbiInterphaseViewController.h"
#import "TextFieldParameterView.h"
#import "AbiinterfaceItem.h"
#import "ContractCoordinator.h"
#import "ResultTokenInputsModel.h"
#import "AbiTextFieldWithLine.h"

@interface CustomAbiInterphaseViewController () <AbiTextFieldWithLineDelegate>

@property (assign, nonatomic) NSInteger activeTextFieldTag;

@end

@implementation CustomAbiInterphaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextFields];
}

#pragma mark - Configuration

- (void)confixHeaderFields {
    
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic-token_not_empty"]];
    image.frame = CGRectMake(10.0f, 22.0f, image.frame.size.width, image.frame.size.height);
    [self.scrollView addSubview:image];
    
    UILabel *type = [[UILabel alloc] init];
    type.text = NSLocalizedString(@"Token", nil);
    type.textColor = customBlueColor();
    type.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
    [type sizeToFit];
    type.frame = CGRectMake(image.frame.origin.x + image.frame.size.width + 5.0f,
                            image.frame.origin.y + image.frame.size.height / 2.0f - type.frame.size.height / 2.0f,
                            type.frame.size.width,
                            type.frame.size.height);
    
    [self.scrollView addSubview:type];
}

-(void)configTextFields {
    
    NSInteger yoffset = 0;
    NSInteger yoffsetFirstElement = 60;
    NSInteger heighOfPrevElement = 0;
    NSInteger heighOfElement = 100;
    NSInteger scrollViewTopOffset = 88;
    NSInteger scrollViewBottomInset = 49;


    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewTopOffset, CGRectGetWidth(self.view.frame), self.view.frame.size.height - scrollViewTopOffset)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self confixHeaderFields];
    
    for (int i = 0; i < self.formModel.constructorItem.inputs.count; i++) {
        TextFieldParameterView *parameterView = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldsViews" owner:self options:nil] lastObject];
        parameterView.frame = CGRectMake(0.0f, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, CGRectGetWidth(self.view.frame), heighOfElement);
        [parameterView.titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Parameter", nil), i + 1]];
        [parameterView.textField setItem:self.formModel.constructorItem.inputs[i]];
        heighOfPrevElement = heighOfElement;
        parameterView.textField.inputAccessoryView = [self createToolBarInput];
        parameterView.textField.customDelegate = self;
        parameterView.tag = i;
        
        [self.scrollView addSubview:parameterView];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
    }
    
    UIButton *nextButton = [[UIButton alloc] init];
    nextButton.frame = CGRectMake((self.view.frame.size.width - 150.0f) / 2.0f, yoffset * self.formModel.constructorItem.inputs.count - 1 + heighOfPrevElement * self.formModel.constructorItem.inputs.count - 1 + yoffsetFirstElement + 30.0f, 150, 32.0f);
    [nextButton setTitle:NSLocalizedString(@"NEXT", nil) forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
    [nextButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
    [nextButton setBackgroundColor:customRedColor()];
    [nextButton addTarget:self action:@selector(didPressedNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:nextButton];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                             nextButton.frame.origin.y + nextButton.frame.size.height + 30.0f);
    
    self.scrollView.contentInset =
    self.originInsets = UIEdgeInsetsMake(0, 0, scrollViewBottomInset, 0);
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
}

#pragma mark - Private Methods

-(NSArray<ResultTokenInputsModel*>*)prepareInputsData {
    
    NSMutableArray* inputsData = @[].mutableCopy;
    for (TextFieldParameterView* parameter in self.scrollView.subviews) {
        if ([parameter isKindOfClass:[TextFieldParameterView class]]) {
            ResultTokenInputsModel* input = [ResultTokenInputsModel new];
            input.name = parameter.textField.item.name;
            input.value = parameter.textField.item.type == StringType ? parameter.textField.text : @([parameter.textField.text integerValue]);
            [inputsData addObject:input];
        }
    }
    return [inputsData copy];
}


- (UIToolbar*)createToolBarInput {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    toolbar.barTintColor = customBlackColor();
    
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

#pragma mark - AbiTextFieldWithLineDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeTextFieldTag = textField.superview.tag;
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedNextOnTextField:(id)sender {
    
    if (self.activeTextFieldTag < self.formModel.constructorItem.inputs.count - 1) {
        TextFieldParameterView *parameter = [self.scrollView viewWithTag:self.activeTextFieldTag + 1];
        UITextField* texField = parameter.textField;
        [texField becomeFirstResponder];
    } else {
        [self didPressedNextAction:nil];
        [self didVoidTapAction:nil];
    }
}

- (IBAction)didPressedNextAction:(id)sender {
    [self.delegate createStepOneNextDidPressedWithInputs:[self prepareInputsData]];
}
- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

@end
