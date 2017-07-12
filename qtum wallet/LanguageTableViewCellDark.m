//
//  LanguageTableViewCellDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LanguageTableViewCellDark.h"

@implementation LanguageTableViewCellDark

- (UIColor *)getDeselectedColor {
    return customBlueColor();
}

- (UIColor *)getSelectedColor {
    return customBlackColor();
}

@end
