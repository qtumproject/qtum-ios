//
//  CustomAbiInterphaseViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CustomAbiInterphaseViewController.h"
#import "AbiTextFieldWithLine.h"
#import "AbiinterfaceItem.h"
#import "ContractCoordinator.h"
#import "ResultTokenInputsModel.h"

@interface CustomAbiInterphaseViewController () <AbiTextFieldWithLineDelegate>

@property (assign, nonatomic) NSInteger activeTextFieldTag;

@end

@implementation CustomAbiInterphaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTextFields];
}

#pragma mark - Configuration

-(void)configTextFields {
    
    NSInteger xoffset = 20;
    NSInteger yoffset = 30;
    NSInteger yoffsetFirstElement = 30;
    NSInteger heighOfPrevElement = 0;
    NSInteger heighOfElement = 30;
    NSInteger widthOfElement = CGRectGetWidth(self.view.frame) - xoffset * 2;
    NSInteger scrollViewTopOffset = 88;
    NSInteger scrollViewBottomInset = 105;


    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewTopOffset, CGRectGetWidth(self.view.frame), self.view.frame.size.height - scrollViewTopOffset)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    for (int i = 0; i < self.formModel.constructorItem.inputs.count; i++) {
        AbiTextFieldWithLine* textField = [[AbiTextFieldWithLine alloc] initWithFrame:CGRectMake(xoffset, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, widthOfElement, heighOfElement) andInterfaceItem:self.formModel.constructorItem.inputs[i]];
        heighOfPrevElement = heighOfElement;
        textField.inputAccessoryView = [self createToolBarInput];
        textField.customDelegate = self;
        textField.tag = i;
        [self.scrollView addSubview:textField];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
    }
    self.scrollView.contentInset =
    self.originInsets = UIEdgeInsetsMake(0, 0, scrollViewBottomInset, 0);
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:self.scrollView];
}

#pragma mark - Private Methods

-(NSArray<ResultTokenInputsModel*>*)prepareInputsData {
    
    NSMutableArray* inputsData = @[].mutableCopy;
    for (AbiTextFieldWithLine* textField in self.scrollView.subviews) {
        if ([textField isKindOfClass:[AbiTextFieldWithLine class]]) {
            ResultTokenInputsModel* input = [ResultTokenInputsModel new];
            input.name = textField.item.name;
            input.value = textField.item.type == StringType ? textField.text : @([textField.text integerValue]);
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
    self.activeTextFieldTag = textField.tag;
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedNextOnTextField:(id)sender {
    
    if (self.activeTextFieldTag < self.formModel.constructorItem.inputs.count - 1) {
        UITextField* texField = (UITextField*)[self.scrollView viewWithTag:self.activeTextFieldTag + 1];
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
