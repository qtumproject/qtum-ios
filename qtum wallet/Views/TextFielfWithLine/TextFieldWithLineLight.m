//
//  TextFieldWithLineLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TextFieldWithLineLight.h"

@implementation TextFieldWithLineLight

- (UIColor *)getUnderlineColorDeselected {
    return lightTextFieldLineDeselected();
}

- (UIColor *)getUnderlineColorSelected {
    return lightGreenColor();
}

- (UIColor *)getPlaceholderColor {
    return lightTextFieldPlaceholderColor();
}

- (UIFont *)getPlaceholderFont {
    return [UIFont fontWithName:@"ProximaNova-Regular" size:self.font.pointSize];
}

@end
