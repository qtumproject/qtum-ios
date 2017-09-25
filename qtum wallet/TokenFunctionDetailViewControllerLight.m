//
//  TokenFunctionDetailViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionDetailViewControllerLight.h"
#import "TextFieldParameterView.h"
#import "ResultTokenInputsModel.h"

@interface TokenFunctionDetailViewControllerLight () <AbiTextFieldWithLineDelegate>

@end

@implementation TokenFunctionDetailViewControllerLight

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
        TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldViewsLight" owner:self options:nil] lastObject];
        parameter.frame = CGRectMake(10.0, yoffset * i + heighOfPrevElement * i + yoffsetFirstElement, CGRectGetWidth(self.view.frame) - 20.f, heighOfElement);
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
        
        SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderViewLight" owner:self options:nil] lastObject];
        feeView.frame = CGRectMake(0, yoffset * self.function.inputs.count - 1 + heighOfPrevElement * self.function.inputs.count - 1 + yoffsetFirstElement + 50.0f, self.view.frame.size.width, 180);
        feeView.delegate = self;
        self.feeView = feeView;
        [self.scrollView addSubview:feeView];
        
        UIButton *callButton = [[UIButton alloc] init];
        callButton.frame = CGRectMake((self.view.frame.size.width - 240.0f) / 2.0f, yoffset * self.function.inputs.count - 1 + heighOfPrevElement * self.function.inputs.count - 1 + yoffsetFirstElement + 50.0f + 180, 240, 50.0f);
        [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
        callButton.layer.cornerRadius = 5;
        callButton.layer.masksToBounds = YES;
        callButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callButton setBackgroundColor:lightGreenColor()];
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
    doneButton.tintColor = lightGreenColor();
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", "") style:UIBarButtonItemStyleDone target:self action:@selector(didPressedNextOnTextField:)];
    cancelButton.tintColor = customBlueColor();
    
    toolbar.items = @[doneButton,
                      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                      cancelButton];
    [toolbar sizeToFit];
    return toolbar;
}


@end
