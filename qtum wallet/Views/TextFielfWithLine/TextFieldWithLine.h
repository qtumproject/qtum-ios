//
//  TextFieldWithLine.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldWithLine : UITextField

@property (nonatomic, assign) CGFloat currentHeight;

@property (nonatomic, readonly) UILabel *placeholderLabel;

- (UIColor *)getUnderlineColorDeselected;
- (UIColor *)getUnderlineColorSelected;
- (UIColor *)getPlaceholderColor;
- (UIFont *)getPlaceholderFont;

@end
