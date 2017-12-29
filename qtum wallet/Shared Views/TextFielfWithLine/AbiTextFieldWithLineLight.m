//
//  AbiTextFieldWithLineLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AbiTextFieldWithLineLight.h"

@interface AbiTextFieldWithLineLight () <UITextFieldDelegate>

@end

@implementation AbiTextFieldWithLineLight

@synthesize customDelegate, item = _item;

- (instancetype)initWithCoder:(NSCoder *) aDecoder {

	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setupWithItem:nil];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect) frame andInterfaceItem:(AbiinterfaceInput *) item {

	self = [super initWithFrame:frame];
	if (self) {
		[self setupWithItem:item];
	}
	return self;
}

- (void)setupWithItem:(AbiinterfaceInput *) item {

	self.currentHeight = 1;
	self.delegate = self;
	if (item) {
		self.item = item;
	}
}

- (BOOL)isValidParameterText {
    
    NSString* text = self.text;
    BOOL isValid = [SLocator.validationInputService isValidString:text forParameter:self.item.type];
    return isValid;
}

- (void)setItem:(AbiinterfaceInput *) item {

	self.keyboardType = ([item.type isKindOfClass:[AbiParameterTypeUInt class]] ||
			[item.type isKindOfClass:[AbiParameterTypeInt class]] ||
			[item.type isKindOfClass:[AbiParameterTypeBool class]]) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:item.name];
    self.appendingTextToPlaceHolder = item.typeAsString;
	_item = item;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string {

    NSString * resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isValid = [SLocator.validationInputService isValidSymbols:resultString forParameter:self.item.type];
    
    if (isValid && [self.customDelegate respondsToSelector:@selector(textDidChange)]) {
        [self.customDelegate textDidChange];
    }
    return isValid;
}

- (void)textFieldDidBeginEditing:(UITextField *) textField {

	if ([self.customDelegate respondsToSelector:@selector (textFieldDidBeginEditing:)]) {
		[self.customDelegate textFieldDidBeginEditing:textField];
	}
}

- (void)textFieldDidEndEditing:(UITextField *) textField {

	if ([self.customDelegate respondsToSelector:@selector (textFieldDidEndEditing:)]) {
		[self.customDelegate textFieldDidEndEditing:textField];
	}
}

@end
