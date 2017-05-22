//
//  TokenFunctionDetailViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenFunctionDetailViewController.h"
#import "AbiTextFieldWithLine.h"
#import "ResultTokenInputsModel.h"

@interface TokenFunctionDetailViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UILabel *result;

@end

@implementation TokenFunctionDetailViewController

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
    NSInteger scrollViewBottomOffset = 100;

    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, scrollViewTopOffset, CGRectGetWidth(self.view.frame), self.view.frame.size.height - scrollViewTopOffset - scrollViewBottomOffset)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    for (int i = 0; i < self.function.inputs.count; i++) {
        AbiTextFieldWithLine* textField = [[AbiTextFieldWithLine alloc] initWithFrame:CGRectMake(xoffset, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, widthOfElement, heighOfElement) andInterfaceItem:self.function.inputs[i]];
        heighOfPrevElement = heighOfElement;
        [self.scrollView addSubview:textField];
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width,
                                                 yoffset * i + heighOfPrevElement * i + yoffsetFirstElement + heighOfElement);
    }
    [self.view addSubview:self.scrollView];
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

#pragma mark - Public Methods 

-(void)showResultViewWithOutputs:(NSArray*) outputs {
    
    [SVProgressHUD dismiss];
    
    NSMutableString* result = [NSMutableString new];
    for (id output in outputs) {
        [result appendFormat:@"%@",output];
    }
    self.result.text = result.length > 0 ? result : @"There is no output";
    self.result.hidden = NO;
    self.scrollView.hidden = YES;
    self.callButton.hidden = YES;
    self.cancelButton.hidden = YES;
}

#pragma mark - Actions

- (IBAction)didPressedCancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressedCallAction:(id)sender {
    [SVProgressHUD show];
    [self.delegate didCallFunctionWithItem:self.function andParam:[self prepareInputsData] andToken:self.token];
}

- (IBAction)didVoidTapAction:(id)sender {
    [self.view endEditing:YES];
}

@end
