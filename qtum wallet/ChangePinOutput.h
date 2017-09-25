//
//  ChangePinOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ChangePinOutputDelegate.h"

@protocol ChangePinOutput <NSObject>

@property (assign,nonatomic) PinType type;

@property (nonatomic, weak) id<ChangePinOutputDelegate> delegate;

- (void)actionIncorrectPin;
- (void)accessPinDenied;
- (void)clearPinTextFields;
- (void)redirectTextField:(UITextField*)textField isReversed:(BOOL) reversed;
- (void)setCustomTitle:(NSString *)title;

@end
