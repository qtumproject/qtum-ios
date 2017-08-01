//
//  AbiTextFieldWithLineLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiTextFieldWithLineLight.h"

@interface AbiTextFieldWithLineLight () <UITextFieldDelegate>

@end

@implementation AbiTextFieldWithLineLight

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
    
    self.currentHeight = 1;
    self.delegate = self;
    if (item) {
        self.item = item;
    }
}

- (void)setItem:(AbiinterfaceInput *)item {
    
    self.keyboardType = (item.type == UInt256Type || item.type == UInt8Type) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:item.name];
    _item = item;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.item.type == UInt8Type || self.item.type == UInt256Type) {
        NSCharacterSet *cset = [NSCharacterSet decimalDigitCharacterSet].invertedSet;
        NSRange range = [string rangeOfCharacterFromSet:cset];
        
        if (range.location != NSNotFound || (self.item.type == UInt8Type && [[textField.text stringByAppendingString:string] integerValue] > 255)) {
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
