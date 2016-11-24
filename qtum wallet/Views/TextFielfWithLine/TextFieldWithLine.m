//
//  TextFieldWithLine.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "TextFieldWithLine.h"

@interface TextFieldWithLine ()

@property (nonatomic) UIView *lineView;

@end

@implementation TextFieldWithLine

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(0, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
}

- (UIView *)lineView
{
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = textFieldLineColorDeselected();
        _lineView = lineView;
        
        [self addSubview:lineView];
    }
    
    return _lineView;
}

- (BOOL)becomeFirstResponder
{
    self.lineView.backgroundColor = textFieldLineColorSelected();
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    self.lineView.backgroundColor = textFieldLineColorDeselected();
    return [super resignFirstResponder];
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text
{
    return [super shouldChangeTextInRange:range replacementText:text];
}

@end
