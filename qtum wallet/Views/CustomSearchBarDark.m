//
//  CustomSearchBarDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CustomSearchBarDark.h"
#import "UIImage+Extension.h"

@implementation CustomSearchBarDark

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self changeFontAndColorButtons];
}

- (void)setup {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8,0, [UIApplication sharedApplication].keyWindow.frame.size.width - 16, 28)];
    view.backgroundColor = customBlackColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [self setSearchFieldBackgroundImage:img forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed: @"Icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self setSearchTextPositionAdjustment:UIOffsetMake(8.0f, 0.0f)];
}


- (void)changeFontAndColorButtons {
    
    for (UIView *view in self.subviews) {
        for (id subview in view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *cancelButton = (UIButton *)subview;
                [cancelButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
                cancelButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16.0f];
            }
        }
    }
}

@end
