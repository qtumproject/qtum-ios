//
//  CustomAbiInterphaseViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CustomAbiInterphaseViewController.h"
#import "AbiTextFieldWithLine.h"
#import "AbiinterfaceItem.h"
#import "CreateTokenCoordinator.h"
#import "ResultTokenCreateInputModel.h"

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


    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewTopOffset, CGRectGetWidth(self.view.frame), self.view.frame.size.height - scrollViewTopOffset)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    for (int i = 0; i < self.formModel.constructorItem.inputs.count; i++) {
        AbiTextFieldWithLine* textField = [[AbiTextFieldWithLine alloc] initWithFrame:CGRectMake(xoffset, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, widthOfElement, heighOfElement) andInterfaceItem:self.formModel.constructorItem.inputs[i]];
        heighOfPrevElement = heighOfElement;
        [self.scrollView addSubview:textField];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
    }
    [self.view addSubview:self.scrollView];
}

#pragma mark - Private Methods

-(NSArray<ResultTokenCreateInputModel*>*)prepareInputsData {
    
    NSMutableArray* inputsData = @[].mutableCopy;
    for (AbiTextFieldWithLine* textField in self.scrollView.subviews) {
        if ([textField isKindOfClass:[AbiTextFieldWithLine class]]) {
            ResultTokenCreateInputModel* input = [ResultTokenCreateInputModel new];
            input.name = textField.item.name;
            input.value = textField.item.type == StringType ? textField.text : @([textField.text integerValue]);
            [inputsData addObject:input];
        }
    }
    return [inputsData copy];
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id)sender {
    [self.delegate createStepOneCancelDidPressed];
}

- (IBAction)didPressedNextAction:(id)sender {
    [self.delegate createStepOneNextDidPressedWithInputs:[self prepareInputsData]];
}
- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

@end
