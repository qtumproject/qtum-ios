//
//  Utils.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const *PUBLIC_ADDRESS_STRING_KEY;
extern NSString const *PRIVATE_ADDRESS_STRING_KEY;
extern NSString const *EXPORT_CONTRACTS_TOKENS_KEY;
extern NSString const *AMOUNT_STRING_KEY;
extern NSString *NO_INTERNET_CONNECTION_ERROR_KEY;
extern NSString const *IS_TOKEN_STRING_KEY;


UIColor *customBlueColor(void);

UIColor *textFieldLineColorSelected(void);

UIColor *textFieldLineColorDeselected(void);

UIColor *customRedColor(void);

UIColor *historyGreenColor(void);

UIColor *historyGrayColor(void);

UIColor *customBlackColor(void);

// Light Colors
UIColor *lightBlueColor(void);

UIColor *lightDarkBlueColor(void);

UIColor *lightDarkBlueColorForGradient(void);

UIColor *lightBlackColor(void);

UIColor *lightBlackColor78(void);

UIColor *lightGreenColor(void);

UIColor *lightTabBarTopLineColor(void);

UIColor *lightGrayColor(void);

UIColor *lightDarkGrayColor(void);

// colors setters depend on theme
UIColor *getQRCodeBackroundColor(void);

UIColor *getQRCodeMainColor(void);

UIColor *lightTextFieldPlaceholderColor(void);

UIColor *lightTextFieldLineDeselected(void);

UIColor *lightBorderLabelBackroundColor(void);

typedef NS_ENUM(NSInteger, PinType) {
	EnterType,
	CreateType,
	ConfirmType,
	NewType,
	OldType
};

@protocol PinCoordinator <NSObject>

@required
- (void)confirmPin:(NSString *) pin andCompletision:(void (^)(BOOL success)) completisiom;

@optional
- (void)confilmPinFailed;

- (void)setAnimationState:(BOOL) isAnimating;

@end
