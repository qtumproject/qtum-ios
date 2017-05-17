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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setTintColor:customBlueColor()];
        _currentHeight = 1;
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSForegroundColorAttributeName: customBlueColor()}];
    }
    return self;
}

- (void)layoutSubviews {
    self.lineView.frame = CGRectMake(0, self.frame.size.height + 13.0f, self.frame.size.width, self.currentHeight);
    [super layoutSubviews];
}

- (UIView *)lineView {
    
    if (!_lineView) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = customBlueColor();
        _lineView = lineView;
        [self addSubview:lineView];
    }
    
    return _lineView;
}

- (BOOL)becomeFirstResponder {
    
    self.lineView.backgroundColor = customBlueColor();
    self.currentHeight = 2;
    [self setNeedsLayout];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    
    self.lineView.backgroundColor = customBlueColor();
    self.currentHeight = 1;
    return [super resignFirstResponder];
}

- (BOOL)shouldChangeTextInRange:(UITextRange *)range replacementText:(NSString *)text {
    
    return [super shouldChangeTextInRange:range replacementText:text];
}

@end
