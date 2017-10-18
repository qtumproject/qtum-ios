//
//  PasswordView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PasswordView.h"
#import "CustomTextField.h"

@interface PasswordView () <UITextFieldDelegate>

@property (strong, nonatomic) UIFont* textFont;
@property (strong, nonatomic) UIColor* fontColor;
@property (strong, nonatomic) UIColor* underlineColor;
@property (strong, nonatomic) UIColor* tintColor;
@property (strong, nonatomic) UIColor* errorFieldColor;
@property (assign, nonatomic) PasswordViewStyle styleType;
@property (assign, nonatomic) PasswordLenghtType lenghtType;

@property (strong, nonatomic) NSMutableArray <NSLayoutConstraint*>*underlineConstraintArray;
@property (strong, nonatomic) NSMutableArray <CustomTextField*>*textFieldsArray;
@property (assign, nonatomic) NSUInteger digitsCount;
@property (assign, nonatomic) NSUInteger underlineWidth;
@property (assign, nonatomic) NSUInteger underlineLeading;
@property (assign, nonatomic) UIView* errorView;
@property (assign, nonatomic) NSString* secretSymbol;

@property (assign, nonatomic) BOOL isEditingDisabled;

@end

@implementation PasswordView

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        _textFieldsArray = @[].mutableCopy;
        _underlineConstraintArray = @[].mutableCopy;
        self.userInteractionEnabled = NO;
        [self calculateSizes];
        [self defineSettings];
        [self createErrorField];
        [self createPinView];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setTextFont:(UIFont*)textFont
          fontColor:(UIColor*)fontColor
     underlineColor:(UIColor*)color
          tintColor:(UIColor*) tintColor
    errorFieldColor:(UIColor*)errorColor {
    
    if (textFont) {
        self.textFont = textFont;
    }
    self.fontColor = fontColor;
    self.underlineColor = color;
    self.tintColor = tintColor;
    self.errorFieldColor = errorColor;
    [self updateViews];
}

- (void)setStyle:(PasswordViewStyle)style
          lenght:(PasswordLenghtType)lenghtType {
    
    if (style != SameStyle || lenghtType != self.lenghtType) {
        
        if (style != SameStyle) {
            self.styleType = style;
        }
        self.lenghtType = lenghtType;
        [self updateViews];
    } 
}

- (void)setEditingDisabled:(BOOL) disabled {
    _isEditingDisabled = disabled;
}

-(void)updateViews {
    
    _textFieldsArray = @[].mutableCopy;
    _underlineConstraintArray = @[].mutableCopy;
    
    self.errorView = nil;
    [self removeAllSubviews];
    [self calculateSizes];
    [self defineSettings];
    [self createErrorField];
    [self createPinView];
}

-(void)calculateSizes {
    
    _digitsCount = _lenghtType == ShortType ? 4 : 6;
    NSUInteger oneItemSize = self.frame.size.width / _digitsCount;
    _underlineWidth = oneItemSize / 100.f * 80;
    _underlineLeading = oneItemSize / 100.f * 20;
}

-(void)defineSettings {
    
    switch (_styleType) {
        case DarkStyle:
            _fontColor = customBlueColor();
            _underlineColor = customBlueColor();
            _textFont = [UIFont fontWithName:@"simplonmono-regular" size:18];
            _secretSymbol = @"■";
            _tintColor = customBlueColor();
            break;
        case DarkPopupStyle:
            _fontColor = customBlackColor();
            _underlineColor = customBlackColor();
            _textFont = [UIFont fontWithName:@"simplonmono-regular" size:18];
            _secretSymbol = @"■";
            _tintColor = customBlackColor();
            break;
        case LightStyle:
            _fontColor = [UIColor whiteColor];
            _underlineColor = [UIColor whiteColor];
            _textFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:30];
            _secretSymbol = @"•";
            _tintColor = lightBlueColor();
            break;
        case LightPopupStyle:
            _fontColor = lightDarkGrayColor();
            _underlineColor = lightTextFieldPlaceholderColor();
            _textFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:30];
            _secretSymbol = @"•";
            _tintColor = lightBlueColor();
            _errorFieldColor = lightBlueColor();
            break;
        default:
            break;
    }
    
    if (!_tintColor) {
        _tintColor = customBlueColor();
    }
    
    if (!_fontColor) {
        _fontColor = customBlueColor();
    }
    
    if (!_underlineColor) {
        _underlineColor = customBlueColor();
    }
    
    if (!_errorFieldColor) {
        _errorFieldColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
    }
    
    if (!_textFont) {
        _textFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:18];
    }
    
    if (!_secretSymbol) {
        _secretSymbol = @"•";
    }
}

-(void)createPinView {
    
    UIView* prevView;
    
    for (int i = 0; i < _digitsCount; i++) {
        prevView = [self addTextFieldWithPrevUnderline:prevView];
    }
}

-(UIView*)addTextFieldWithPrevUnderline:(UIView*) prevUnderline {
    
    CustomTextField* textField = [[CustomTextField alloc] initWithFrame:CGRectZero];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.font = _textFont;
    textField.textColor = _fontColor;
    textField.backgroundColor = [UIColor clearColor];
    textField.delegate = self;
    textField.tintColor = _tintColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.textFieldsArray addObject:textField];
    [self addSubview:textField];
    
    UIView* underlineView = [[UIView alloc] initWithFrame:CGRectZero];
    underlineView.translatesAutoresizingMaskIntoConstraints = NO;
    underlineView.backgroundColor = _underlineColor;
    [self addSubview:underlineView];
    
    NSDictionary *metrics = @{@"underlineSuperviewLeading" : @(_underlineLeading / 2),
                              @"underlineLeading" : @(_underlineLeading),
                              @"underlineWidth" : @(_underlineWidth),
                              @"textFieldHeight" : @(30),
                              @"textFieldTopOffset" : @(20),
                              @"textFieldBottomOffset" : @(10),
                              };

    NSDictionary *views = @{@"underline" : underlineView,
                            @"textField" : textField,
                            @"prevUnderline" : prevUnderline ? prevUnderline : [NSNull new]
                            };
    
    NSArray *horisontalConstraints;

    if (prevUnderline) {
        horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[prevUnderline]-underlineLeading-[underline(underlineWidth)]" options:0 metrics:metrics views:views];
    } else {
        horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-underlineSuperviewLeading-[underline(underlineWidth)]" options:0 metrics:metrics views:views];
    }
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-textFieldTopOffset-[textField(textFieldHeight)]-textFieldBottomOffset-[underline]" options:0 metrics:metrics views:views];
    
    NSLayoutConstraint* height = [NSLayoutConstraint constraintWithItem:underlineView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:1];
    NSLayoutConstraint* center = [NSLayoutConstraint constraintWithItem:underlineView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:textField
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0];
    NSLayoutConstraint* width = [NSLayoutConstraint constraintWithItem:textField
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:30];
    [self.underlineConstraintArray addObject:height];
    
    [self addConstraint:width];
    [self addConstraint:center];
    [self addConstraint:height];
    [self addConstraints:verticalConstraints];
    [self addConstraints:horisontalConstraints];
    
    return underlineView;
}

-(void)createErrorField {
    
    UIView* conteinerView = [[UIView alloc] initWithFrame:CGRectZero];
    conteinerView.translatesAutoresizingMaskIntoConstraints = NO;
    conteinerView.backgroundColor = _errorFieldColor;
    conteinerView.layer.masksToBounds = YES;
    conteinerView.layer.cornerRadius = 3;
    conteinerView.alpha = 0;
    self.errorView = conteinerView;
    [self  addSubview:conteinerView];

    NSDictionary *metrics = @{@"height" : @(25.0f), @"width" : @(200.0f)};
    NSDictionary *views = @{@"conteinerView" : conteinerView};
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[conteinerView(height)]-0-|" options:0 metrics:metrics views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[conteinerView(width)]" options:0 metrics:metrics views:views];
    
    NSLayoutConstraint* center = [NSLayoutConstraint constraintWithItem:conteinerView
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0];
    [self addConstraints:verticalConstraints];
    [self addConstraints:horisontalConstraints];
    [self addConstraint:center];
    
    UILabel* errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    errorLabel.backgroundColor = [UIColor clearColor];
    errorLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:12];
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    errorLabel.text = NSLocalizedString(@"PIN is invalid. Please Try Again.", nil);
    [conteinerView addSubview:errorLabel];

    views = @{@"errorLabel" : errorLabel};
    
    verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[errorLabel]-0-|" options:0 metrics:metrics views:views];
    horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[errorLabel]-0-|" options:0 metrics:nil views:views];
    
    [conteinerView addConstraints:verticalConstraints];
    [conteinerView addConstraints:horisontalConstraints];
    
    [conteinerView addSubview:errorLabel];
}

-(void)removeAllSubviews {
    
    for (UIView * subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

#pragma mark - UITextFieldDelegate

-(void)redirectTextField:(CustomTextField*)textField isReversed:(BOOL) reversed {
    
    NSUInteger index = [self.textFieldsArray indexOfObject:textField];
    
    if (reversed) {
        
        if (index > 0) {
            [self.textFieldsArray[index - 1] becomeFirstResponder];
        }
    } else {

        if (index >= self.textFieldsArray.count - 1) {
            [self actionEnter:nil];
        } else {
            [self.textFieldsArray[index + 1] becomeFirstResponder];
        }
    }
}

-(void)accessPinDenied {
    
    [self shakeAndClearText];
    [self actionIncorrectPin];
    [self.textFieldsArray[0] becomeFirstResponder];
}

-(void)shakeAndClearText {
    CAKeyframeAnimation* shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.duration = 0.6;
    shake.values = @[@-20.0, @20.0, @-20.0, @20.0, @-10.0, @10.0, @-5.0, @5.0, @0.0];
    shake.delegate = self;
    [self.layer addAnimation:shake forKey:@"shake"];
    [self clearPinTextFields];
}

-(void)clearPinTextFields {
    
    for (CustomTextField* textField in self.textFieldsArray) {
        textField.realText =
        textField.text = @"";
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        //        if ([self.delegate respondsToSelector:@selector(confilmPinFailed)]) {
        //            [self.delegate confilmPinFailed];
        //        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidBeginEditing:(CustomTextField *)textField{
    
    NSUInteger index = [self.textFieldsArray indexOfObject:textField];
    if (NSNotFound != index) {
        self.underlineConstraintArray[index].constant = 4;
        [self setNeedsLayout];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(CustomTextField *)textField {
    
    NSUInteger index = [self.textFieldsArray indexOfObject:textField];
    if (NSNotFound != index) {
        self.underlineConstraintArray[index].constant = 2;
        [self setNeedsLayout];
    }
}

- (BOOL)textField:(CustomTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.isEditingDisabled) {
        return NO;
    }
    
    if (string.length && [string rangeOfString:@" "].location == NSNotFound) {
        textField.realText = [string substringToIndex:1];
        textField.text = _secretSymbol;
        [self redirectTextField:textField isReversed:NO];
    }else {
        textField.text = @"";
        [self redirectTextField:textField isReversed:YES];
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self endEditing:YES];
    return YES;
}

#pragma mark - Actions

-(void)actionEnter:(id)sender {
    
    [self.delegate confirmPinWithDigits:[self getDigits]];
}

#pragma mark -

-(void)actionIncorrectPin {
    
    [self.errorView setAlpha:0.0f];
    
    [UIView animateWithDuration:2.0f animations:^{
        [self.errorView setAlpha:1.0f];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:2.0f animations:^{
            [self.errorView setAlpha:0.0f];
        } completion:nil];
    }];
}

-(void)becameFirstResponder {
    
    if (self.textFieldsArray.count > 0) {
        [self.textFieldsArray[0] becomeFirstResponder];
    }
}

-(NSString*)getDigits {
    
    NSString* digits = @"";
    for (CustomTextField* textField in self.textFieldsArray) {
        
        digits = [digits stringByAppendingString:textField.realText ?: @""];
    }
    
    return digits;
}

- (BOOL)isValidPasswordLenght {
    
    return self.textFieldsArray.count == [self getDigits].length;
}


@end
