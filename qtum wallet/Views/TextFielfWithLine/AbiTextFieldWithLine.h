//
//  AbiTextFieldWithLine.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TextFieldWithLine.h"
#import "AbiinterfaceInput.h"

@protocol AbiTextFieldWithLineDelegate <NSObject>

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (BOOL)textFieldShouldClear:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end

@interface AbiTextFieldWithLine : TextFieldWithLine

-(instancetype)initWithFrame:(CGRect)frame andInterfaceItem:(AbiinterfaceInput*) item;

@property (weak, nonatomic) id <AbiTextFieldWithLineDelegate> customDelegate;
@property (strong,nonatomic, readonly)AbiinterfaceInput* item;

@end
