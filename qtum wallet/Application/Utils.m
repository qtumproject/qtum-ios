//
//  Utils.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "NSUserDefaults+Settings.h"

NSString const *PUBLIC_ADDRESS_STRING_KEY = @"publicAddress";
NSString const *EXPORT_CONTRACTS_TOKENS_KEY = @"export_contracts_tokens";
NSString const *IS_TOKEN_STRING_KEY = @"isToken";
NSString const *PRIVATE_ADDRESS_STRING_KEY = @"privateAddress";
NSString const *AMOUNT_STRING_KEY = @"amount";
NSString *NO_INTERNET_CONNECTION_ERROR_KEY = @"no_internet_connection_error_key";


UIColor *customBlueColor() {
	return [UIColor colorWithRed:46 / 255.0f green:154 / 255.0f blue:208 / 255.0f alpha:1.0f];
}

UIColor *customRedColor() {
	return [UIColor colorWithRed:231 / 255.0f green:86 / 255.0f blue:71 / 255.0f alpha:1.0f];
}

UIColor *customBlackColor() {
	return [UIColor colorWithRed:35 / 255.0f green:35 / 255.0f blue:40 / 255.0f alpha:1.0f];
}

UIColor *historyGreenColor() {
	return [UIColor colorWithRed:83 / 255.0f green:205 / 255.0f blue:204 / 255.0f alpha:1.0f];
}

UIColor *historyGrayColor() {
	return [UIColor grayColor];
}

UIColor *textFieldLineColorSelected() {
	return [UIColor colorWithRed:54 / 255.0f green:185 / 255.0f blue:200 / 255.0f alpha:1.0f];
}

UIColor *textFieldLineColorDeselected() {
	return [UIColor colorWithRed:189 / 255.0f green:198 / 255.0f blue:207 / 255.0f alpha:1.0f];
}

// Light Colors

UIColor *lightBlueColor() {
	return [UIColor colorWithRed:237 / 255.0f green:246 / 255.0f blue:248 / 255.0f alpha:1.0f];
}

UIColor *lightGreenColor() {
	return [UIColor colorWithRed:54 / 255.0f green:185 / 255.0f blue:200 / 255.0f alpha:1.0f];
}

UIColor *lightDarkBlueColor() {
	return [UIColor colorWithRed:54 / 255.0f green:85 / 255.0f blue:200 / 255.0f alpha:1.0f];
}

UIColor *lightDarkBlueColorForGradient() {
	return [UIColor colorWithRed:63 / 255.0f green:56 / 255.0f blue:196 / 255.0f alpha:1.0f];
}

UIColor *lightBlackColor() {
	return [UIColor colorWithRed:83 / 255.0f green:97 / 255.0f blue:115 / 255.0f alpha:1.0f];
}

UIColor *lightBlackColor78() {
	return [UIColor colorWithRed:78 / 255.0f green:93 / 255.0f blue:111 / 255.0f alpha:1.0f];
}

UIColor *lightTabBarTopLineColor() {
	return [UIColor colorWithRed:231 / 255.0f green:240 / 255.0f blue:242 / 255.0f alpha:1.0f];
}

UIColor *lightGrayColor() {
	return [UIColor colorWithRed:83 / 255.0f green:97 / 255.0f blue:115 / 255.0f alpha:0.6f];
}

UIColor *lightDarkGrayColor() {
	return [UIColor colorWithRed:83 / 255.0f green:97 / 255.0f blue:115 / 255.0f alpha:1.0f];
}

UIColor *lightTextFieldLineDeselected() {
	return [UIColor colorWithRed:220 / 255.0f green:223 / 255.0f blue:226 / 255.0f alpha:1.0f];
}

UIColor *lightTextFieldPlaceholderColor() {
	return [UIColor colorWithRed:166 / 255.0f green:174 / 255.0f blue:183 / 255.0f alpha:0.5f];
}

UIColor *lightBorderLabelBackroundColor() {
	return [UIColor colorWithRed:247 / 255.0f green:247 / 255.0f blue:247 / 255.0f alpha:1.0f];
}

// colors setters depend on theme

UIColor *getQRCodeBackroundColor() {

	UIColor *color = [NSUserDefaults isDarkSchemeSetting] ? customBlueColor () : lightBlueColor ();
	return color;
}

UIColor *getQRCodeMainColor() {

	UIColor *color = [NSUserDefaults isDarkSchemeSetting] ? customBlackColor () : [UIColor colorWithRed:60 / 255.0f green:135 / 255.0f blue:185 / 255.0f alpha:1.0f];
	return color;
}
