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
    
    self.scrollView = [UIScrollView new];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:scrollViewTopOffset];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraints:@[left, right, top, bottom]];
    
    NSMutableArray *params = [NSMutableArray new];
    for (int i = 0; i < self.function.inputs.count; i++) {
        TextFieldParameterView *parameter = (TextFieldParameterView *)[[[NSBundle mainBundle] loadNibNamed:@"FieldViewsLight" owner:self options:nil] lastObject];
        [params addObject:parameter];
        parameter.translatesAutoresizingMaskIntoConstraints = NO;
        [parameter.textField setItem:self.function.inputs[i]];
        [parameter.titleLabel setText:[NSString stringWithFormat:@"%@ %d", NSLocalizedString(@"Parameter", nil), i + 1]];
        heighOfPrevElement = heighOfElement;
        parameter.textField.inputAccessoryView = [self createToolBarInput];
        parameter.textField.customDelegate = self;
        parameter.tag = i;
        
        [self.scrollView addSubview:parameter];
        
        UIView *topItem;
        UIView *bottomItem;
        if (i == 0) {
            topItem = self.scrollView;
        } else {
            topItem = [params objectAtIndex:i - 1];
            if (i == self.function.inputs.count - 1 && self.fromQStore) {
                bottomItem = self.scrollView;
            }
        }
        
        if (i == 0) {
            NSLayoutConstraint *center = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            [self.scrollView addConstraint:center];
        }
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f];
        
        [self.scrollView addConstraint:left];
        [self.scrollView addConstraint:right];
        
        if (bottomItem) {
            NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomItem attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
            [self.scrollView addConstraint:bottom];
        }
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:parameter attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topItem attribute:(i == 0) ? NSLayoutAttributeTop : NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
        [self.scrollView addConstraint:top];
    }
    
    if (!self.fromQStore) {
        SliderFeeView *feeView = (SliderFeeView *)[[[NSBundle mainBundle] loadNibNamed:@"SliderViewLight" owner:self options:nil] lastObject];
        feeView.translatesAutoresizingMaskIntoConstraints = NO;
        feeView.delegate = self;
        feeView.feeTextField.delegate = self;
        self.feeView = feeView;
        [self.scrollView addSubview:feeView];
        
        NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20.0f];
        
        if (params.count == 0) {
            NSLayoutConstraint *center = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
            
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:30.0f];
            
            [self.scrollView addConstraint:center];
            [self.scrollView addConstraint:top];
        } else {
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:feeView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:[params lastObject] attribute:NSLayoutAttributeBottom multiplier:1.0f constant:30.0f];
            
            [self.scrollView addConstraint:top];
        }
        
        [self.scrollView addConstraints:@[left, right]];
        
        UIButton *callButton = [[UIButton alloc] init];
        callButton.translatesAutoresizingMaskIntoConstraints = NO;
        [callButton setTitle:NSLocalizedString(@"CALL", nil) forState:UIControlStateNormal];
        callButton.layer.cornerRadius = 5;
        callButton.layer.masksToBounds = YES;
        callButton.titleLabel.font = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callButton setBackgroundColor:lightGreenColor()];
        [callButton addTarget:self action:@selector(didPressedCallAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:callButton];
        
        NSLayoutConstraint *topButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:feeView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:30.0f];
        NSLayoutConstraint *bottomButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:20.0f];
        NSLayoutConstraint *centerButton = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:150.0f];
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:callButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:50.0f];
        
        [callButton addConstraint:width];
        [callButton addConstraint:height];
        [self.scrollView addConstraints:@[topButton, bottomButton, centerButton]];
    }
    
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
