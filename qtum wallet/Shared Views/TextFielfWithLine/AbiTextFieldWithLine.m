//
//  AbiTextFieldWithLine.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AbiTextFieldWithLine.h"

@interface AbiTextFieldWithLine () <UITextFieldDelegate>

@end

@implementation AbiTextFieldWithLine

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

	[self setTintColor:customBlueColor ()];
	self.textColor = customBlueColor ();
	self.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
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
	self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSForegroundColorAttributeName: customBlueColor ()}];
    self.appendingTextToPlaceHolder = item.typeAsString;
	_item = item;
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange) range replacementString:(NSString *) string {

    NSString* resultString = [textField.text stringByAppendingString:string];
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
