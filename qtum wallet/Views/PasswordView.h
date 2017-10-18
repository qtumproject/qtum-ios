//
//  PasswordView.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PasswordViewStyle) {
    CustomStyle,
    LightStyle,
    DarkStyle
};

typedef NS_ENUM(NSUInteger, PasswordLenghtType) {
    ShortType,
    LongType
};

@protocol PasswordViewDelegate <NSObject>

-(void)confirmPinWithDigits:(NSString*)digits;

@end

@interface PasswordView : UIView

@property (weak, nonatomic) id <PasswordViewDelegate> delegate;

- (void)startEditing;

- (void)setTextFont:(UIFont*)textFont
          fontColor:(UIColor*)fontColor
     underlineColor:(UIColor*)color
          tintColor:(UIColor*)tintColor
    errorFieldColor:(UIColor*)errorColor;

- (void)setStyle:(PasswordViewStyle)style
          lenght:(PasswordLenghtType)lenghtType;

- (NSString*)getDigits;
- (void)actionIncorrectPin;
- (void)accessPinDenied;
- (void)clearPinTextFields;

@end
