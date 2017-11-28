//
//  TextFieldWithLine.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldWithLine : UITextField

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (strong, nonatomic) NSString* appendingTextToPlaceHolder;

- (void)setEnablePast:(BOOL) value;

- (UIColor *)getUnderlineColorDeselected;

- (UIColor *)getUnderlineColorSelected;

- (UIColor *)getPlaceholderColor;

- (UIFont *)getPlaceholderFont;

@end
