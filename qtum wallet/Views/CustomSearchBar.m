//
//  CustomSearchBar.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CustomSearchBar.h"
#import "UIImage+Extension.h"

@interface CustomSearchBar()

@property (nonatomic) BOOL buttonsCustomized;

@end

@implementation CustomSearchBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8,0, [UIApplication sharedApplication].keyWindow.frame.size.width - 16, 28)];
    view.backgroundColor = customBlackColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [self setSearchFieldBackgroundImage:img forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed: @"Icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self setSearchTextPositionAdjustment:UIOffsetMake(8.0f, 0.0f)];
}

- (void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated {
    [super setShowsCancelButton:showsCancelButton animated:animated];
    
    if (!self.buttonsCustomized) {
        self.buttonsCustomized = YES;
        [self changeFontAndColorButtons];
    }
}

- (void)changeFontAndColorButtons {
    for (UIView *view in self.subviews) {
        for (id subview in view.subviews) {
            if ( [subview isKindOfClass:[UIButton class]] ) {
                UIButton *cancelButton = (UIButton *)subview;
                [cancelButton setTitleColor:customBlackColor() forState:UIControlStateNormal];
                cancelButton.titleLabel.font = [UIFont fontWithName:@"simplonmono-regular" size:16.0f];
                
                break;
            }
        }
    }
}

@end
