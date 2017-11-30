//
//  TokenFunctionDetailViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractFunctionDetailOutput.h"
#import "SliderFeeView.h"

@class Contract;
@class QueryFunctionView;
@class MASConstraint;

@interface TokenFunctionDetailViewController : BaseViewController <ScrollableContentViewController, ContractFunctionDetailOutput, SliderFeeViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) SliderFeeView *feeView;
@property (weak, nonatomic) TextFieldWithLine* amountTextField;

@property (strong, nonatomic) UIView* lastViewInScroll;
@property (nonatomic, strong) MASConstraint *lastViewInScrollBottomOffset;
@property (weak, nonatomic) IBOutlet UIButton *callButton;

- (IBAction)didPressedNextOnTextField:(id) sender;

- (IBAction)didPressedCancelAction:(id) sender;

- (IBAction)didPressedCallAction:(id) sender;

- (IBAction)didVoidTapAction:(id) sender;

@end
