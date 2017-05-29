//
//  CustomAbiInterphaseViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CustomAbiInterphaseViewController.h"
#import "AbiTextFieldWithLine.h"
#import "AbiinterfaceItem.h"
#import "CreateTokenCoordinator.h"
#import "ResultTokenInputsModel.h"

@interface CustomAbiInterphaseViewController ()


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
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    toolbar.barTintColor = customBlueColor();
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", "") style:UIBarButtonItemStyleDone target:self action:@selector(didPressedCancelAction:)];
    doneButton.tintColor = customBlackColor();
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(didPressedNextAction:)];
    cancelButton.tintColor = customBlackColor();
    toolbar.items = @[doneButton,
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      cancelButton];
    [toolbar sizeToFit];
    return toolbar;
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedNextAction:(id)sender {
    [self.delegate createStepOneNextDidPressedWithInputs:[self prepareInputsData]];
}
- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

@end
