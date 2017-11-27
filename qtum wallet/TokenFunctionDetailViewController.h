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

@interface TokenFunctionDetailViewController : BaseViewController <ScrollableContentViewController, ContractFunctionDetailOutput, SliderFeeViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) SliderFeeView *feeView;
@property (weak, nonatomic) TextFieldWithLine* amountTextField;

- (IBAction)didPressedNextOnTextField:(id) sender;

- (IBAction)didPressedCancelAction:(id) sender;

- (IBAction)didPressedCallAction:(id) sender;


@end
