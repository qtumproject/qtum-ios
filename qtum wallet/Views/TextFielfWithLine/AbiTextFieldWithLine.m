//
//  AbiTextFieldWithLine.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiTextFieldWithLine.h"

@interface AbiTextFieldWithLine () <UITextFieldDelegate>

@end

@implementation AbiTextFieldWithLine

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithItem:nil];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andInterfaceItem:(AbiinterfaceInput*) item {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithItem:item];
    }
    return self;
}

- (void)setupWithItem:(AbiinterfaceInput*) item {
    
    [self setTintColor:customBlueColor()];
    self.textColor = customBlueColor();
    self.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
    self.currentHeight = 1;
    self.delegate = self;
    if (item) {
        self.item = item;
    }
}

- (void)setItem:(AbiinterfaceInput *)item {
    
    self.keyboardType = ([item.type isKindOfClass:[AbiParameterTypeUInt class]] ||
                         [item.type isKindOfClass:[AbiParameterTypeInt class]] ||
                         [item.type isKindOfClass:[AbiParameterTypeBool class]]) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSForegroundColorAttributeName: customBlueColor()}];
    _item = item;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([self.item.type isKindOfClass:[AbiParameterTypeUInt class]] ||
        [self.item.type isKindOfClass:[AbiParameterTypeInt class]] ||
        [self.item.type isKindOfClass:[AbiParameterTypeBool class]]) {
        NSCharacterSet *cset = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
        NSRange range = [string rangeOfCharacterFromSet:cset];
        
        AbiParameterPrimitiveType* type = self.item.type;
        if (range.location != NSNotFound || [[textField.text stringByAppendingString:string] integerValue] > type.maxValue) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([self.customDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [self.customDelegate textFieldDidBeginEditing:textField];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([self.customDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.customDelegate textFieldDidEndEditing:textField];
    }
}

@end
