//
//  TextFieldWithLineDarkPopup.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TextFieldWithLineDarkPopup.h"

@implementation TextFieldWithLineDarkPopup

- (UIColor *)getUnderlineColorDeselected {
    return customBlackColor();
}

- (UIColor *)getUnderlineColorSelected {
    return customBlackColor();
}

- (UIColor *)getPlaceholderColor {
    return customBlackColor();
}

@end
