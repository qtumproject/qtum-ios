//
//  TextFieldWithLine.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "TextFieldWithLine.h"

CGFloat const kCenterYChanges = 20.0f;

@interface TextFieldWithLine ()

@property (nonatomic) UIView *lineView;
@property (nonatomic) UILabel *placeholderLabel;
@property (nonatomic) BOOL pastEnabled;

@property (nonatomic) NSLayoutConstraint *centerYConstraintForLabel;
@property (nonatomic) NSLayoutConstraint *centerXConstraintForLabel;
@property (nonatomic) NSLayoutConstraint *leadingConstraintForLabel;

@end

@implementation TextFieldWithLine

- (instancetype)initWithCoder:(NSCoder *) coder {
	self = [super initWithCoder:coder];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (instancetype)initWithFrame:(CGRect) frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {

	_currentHeight = 1;
	_pastEnabled = YES;
	//    [self setTintColor:[self getPlaceholderColor]];
	[self createPlaceholderLabel];
}

- (void)layoutSubviews {

	self.lineView.frame = CGRectMake (0, self.frame.size.height + 9.0f, self.frame.size.width, self.currentHeight);

	[super layoutSubviews];
}

- (void)createPlaceholderLabel {

	_placeholderLabel = [UILabel new];
	_placeholderLabel.font = [self getPlaceholderFont];
	_placeholderLabel.textColor = [self getPlaceholderColor];
	_placeholderLabel.text = self.placeholder;
	[super setPlaceholder:@""];
	_placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
	[_placeholderLabel sizeToFit];

	[self addSubview:_placeholderLabel];

	_centerYConstraintForLabel = [NSLayoutConstraint constraintWithItem:_placeholderLabel
															  attribute:NSLayoutAttributeCenterY
															  relatedBy:NSLayoutRelationEqual
																 toItem:self
															  attribute:NSLayoutAttributeCenterY
															 multiplier:1.0f
															   constant:0.0f];
	[self addConstraint:_centerYConstraintForLabel];

	if (self.textAlignment == NSTextAlignmentCenter) {
		_centerXConstraintForLabel = [NSLayoutConstraint constraintWithItem:_placeholderLabel
																  attribute:NSLayoutAttributeCenterX
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self
																  attribute:NSLayoutAttributeCenterX
																 multiplier:1.0f
																   constant:0.0f];
		[self addConstraint:_centerXConstraintForLabel];
	} else {
		_leadingConstraintForLabel = [NSLayoutConstraint constraintWithItem:_placeholderLabel
																  attribute:NSLayoutAttributeLeft
																  relatedBy:NSLayoutRelationEqual
																	 toItem:self
																  attribute:NSLayoutAttributeLeft
																 multiplier:1.0f
																   constant:0.0f];
		[self addConstraint:_leadingConstraintForLabel];
	}
}

- (UIView *)lineView {

	if (!_lineView) {
		UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
		lineView.backgroundColor = [self getUnderlineColorDeselected];
		_lineView = lineView;
		[self addSubview:lineView];
	}

	return _lineView;
}

- (void)setEnablePast:(BOOL) value {

	self.pastEnabled = value;
}

#pragma mark - Standart Methods

- (void)setText:(NSString *) text {

	if (text && ![text isEqualToString:@""]) {
		[self moveLabelUp:NO];
	} else {
		[self moveLabelDown:NO];
	}

	[super setText:text];
}

- (BOOL)canPerformAction:(SEL) action withSender:(id) sender {

	BOOL standart = [super canPerformAction:action withSender:self];
	if (!standart) {
		return standart;
	}

	if (action == @selector (paste:) && !self.pastEnabled) {
		return NO;
	}

	return YES;
}

- (void)setAttributedPlaceholder:(NSAttributedString *) attributedPlaceholder {

	[self.placeholderLabel setText:attributedPlaceholder.string];
	[self.placeholderLabel sizeToFit];

	[super setAttributedPlaceholder:[NSAttributedString new]];
}

- (void)setPlaceholder:(NSString *) placeholder {

	self.placeholderLabel.text = placeholder;

	[super setPlaceholder:@""];
}

- (BOOL)becomeFirstResponder {

	self.lineView.backgroundColor = [self getUnderlineColorSelected];
	self.currentHeight = 2;

	[self moveLabelUp:YES];

	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {

	self.lineView.backgroundColor = [self getUnderlineColorDeselected];
	self.currentHeight = 1;

	if ([self.text isEqualToString:@""]) {
		[self moveLabelDown:YES];
	}

	return [super resignFirstResponder];
}

- (BOOL)shouldChangeTextInRange:(UITextRange *) range replacementText:(NSString *) text {

	return [super shouldChangeTextInRange:range replacementText:text];
}

#pragma mark - Animation

- (void)moveLabelUp:(BOOL) animated {
	if (self.centerYConstraintForLabel.constant != 0) {
		return;
	}

	self.centerYConstraintForLabel.constant = self.centerYConstraintForLabel.constant - kCenterYChanges;
	self.leadingConstraintForLabel.constant = self.leadingConstraintForLabel.constant - (self.placeholderLabel.frame.size.width * 0.25f) / 2;

	if (animated) {
		[UIView animateWithDuration:0.2f animations:^{
			self.placeholderLabel.transform = CGAffineTransformScale (self.placeholderLabel.transform, 0.75f, 0.75f);
			[self layoutIfNeeded];
		}];
	} else {
		self.placeholderLabel.transform = CGAffineTransformScale (self.placeholderLabel.transform, 0.75f, 0.75f);
		[self layoutIfNeeded];
	}
}

- (void)moveLabelDown:(BOOL) animated {
	if (self.centerYConstraintForLabel.constant == 0) {
		return;
	}

	self.centerYConstraintForLabel.constant = 0;
	self.leadingConstraintForLabel.constant = 0;

	if (animated) {
		[UIView animateWithDuration:0.2f animations:^{
			self.placeholderLabel.transform = CGAffineTransformScale (self.placeholderLabel.transform, 1.0f / 0.75f, 1.0f / 0.75f);
			[self layoutIfNeeded];
		}];
	} else {
		self.placeholderLabel.transform = CGAffineTransformScale (self.placeholderLabel.transform, 1.0f / 0.75f, 1.0f / 0.75f);
		[self layoutIfNeeded];
	}
}

#pragma mark - Methods for childs

- (UIColor *)getUnderlineColorDeselected {
	//    return [UIColor whiteColor];
	return customBlueColor ();
}

- (UIColor *)getUnderlineColorSelected {
	//    return [UIColor whiteColor];
	return customBlueColor ();
}

- (UIColor *)getPlaceholderColor {
	//    return [UIColor whiteColor];
	return customBlueColor ();
}

- (UIFont *)getPlaceholderFont {
	return self.font;
}

@end
