//
//  TokenCellDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenCellDark.h"

@implementation TokenCellDark

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)changeHighlight:(BOOL)value {
    
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            ((UILabel *)view).textColor = value ? customBlackColor() : customBlueColor();
        }
    }
}

@end
