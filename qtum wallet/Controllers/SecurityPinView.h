//
//  SecurityPinView.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@protocol SecurityPinViewDelegate <NSObject>

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completisiom;

@end

@interface SecurityPinView : UIView

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

@property (weak,nonatomic) id <SecurityPinViewDelegate> delegate;

- (void)actionIncorrectPin;
- (void)accessPinDenied;
- (void)clearPinTextFields;

@end
