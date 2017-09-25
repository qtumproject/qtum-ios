//
//  SecurityPopupViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "LoginViewOutput.h"

@interface SecurityPopupViewController : PopUpViewController <LoginViewOutput>

@property (nonatomic, weak) id<SecurityPopupViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet CustomTextField *firstSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *secondSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *thirdSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *fourthSymbolTextField;
@property (weak, nonatomic) IBOutlet UIView *pinContainer;
@property (weak, nonatomic) IBOutlet UIView *incorrectPinView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstInputViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondInputViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thridInputViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthInputViewHeight;
@property (weak, nonatomic) IBOutlet UIView *firstInputUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *secondInputUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *thridInputUnderlineView;
@property (weak, nonatomic) IBOutlet UIView *fourthInputUnderlineView;


- (void)applyFailedPasswordAction;
- (void)clearPinTextFields;
- (void)redirectTextField:(UITextField*)textField isReversed:(BOOL) reversed;

@end
