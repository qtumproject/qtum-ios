//
//  AbiTextFieldWithLine.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AbiTextFieldWithLine.h"

@interface AbiTextFieldWithLine () <UITextFieldDelegate>

@property (strong,nonatomic)AbiinterfaceInput* item;

@end

@implementation AbiTextFieldWithLine

-(instancetype)initWithFrame:(CGRect)frame andInterfaceItem:(AbiinterfaceInput*) item {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.keyboardType = (item.type == UInt256Type || item.type == UInt8Type) ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSForegroundColorAttributeName: customBlueColor()}];
        [self setTintColor:customBlueColor()];
        self.textColor = customBlueColor();
        self.font = [UIFont fontWithName:@"simplonmono-regular" size:16];
        self.currentHeight = 1;
        _item = item;
        self.delegate = self;
    }
    return self;
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text {
    if (self.item.type == UInt8Type || self.item.type == UInt256Type) {
        NSCharacterSet *cset = [NSCharacterSet symbolCharacterSet];
        NSRange range = [text rangeOfCharacterFromSet:cset];
        
        if (range.location == NSNotFound) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.item.type == UInt8Type || self.item.type == UInt256Type) {
        NSCharacterSet *cset = [NSCharacterSet symbolCharacterSet];
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

@end
