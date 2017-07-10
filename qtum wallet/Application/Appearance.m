//
//  Appearance.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "Appearance.h"
#import "UIImage+Extension.h"
#import "TextFieldWithLine.h"
#import "CustomTextField.h"
#import "NSUserDefaults+Settings.h"

@implementation Appearance

+ (void)setUp {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        [self configDarkAppearance];
    } else {
        [self configLightAppearance];
    }
}

#pragma mark - Dark Appearance

+ (void)configDarkAppearance {
    
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setForegroundColor:customBlackColor()];
    [[SVProgressHUD appearance] setBackgroundColor:customRedColor()];
    [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SVProgressHUD appearance] setMinimumDismissTimeInterval:1];
    [[SVProgressHUD appearance] setCornerRadius:0];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : customBlueColor(),
                                                         NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:11.0f]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : customBlueColor(),
                                                         NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:11.0f]}
                                             forState:UIControlStateSelected];
    //color for text in searchfield
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:customBlueColor(),
                                                                                                 NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:15.0f]}];
    
    //color for placeholder in searchfield
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:customBlueColor()];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setClearButtonMode:UITextFieldViewModeNever];
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : customBlueColor(),
                                                            NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:16.0f]}
                                                forState:UIControlStateNormal];
    [self configTabbarUndeline];
    [self configTabbarToplineDark];
}

+ (void)configTabbarUndeline {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake([UITabBar appearance].frame.origin.x,[UITabBar appearance].frame.origin.y, 50, 56)];
    UIImageView *border = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.size.height-6, 50, 6)];
    border.backgroundColor = customBlueColor();
    [view addSubview:border];
    UIImage *img = [UIImage changeViewToImage:view];
    [[UITabBar appearance] setSelectionIndicatorImage:img];
    [[UITabBar appearance] setTintColor: customBlueColor()];
}

+ (void)configTabbarToplineDark {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 1, 1)];
    view.backgroundColor = customBlueColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:img];
}

#pragma mark - Light Appearance

+ (void)configLightAppearance {
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : lightGrayColor(),
                                                         NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:11.0f]}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : lightDarkGrayColor(),
                                                         NSFontAttributeName:[UIFont fontWithName:@"ProximaNova-Regular" size:11.0f]}
                                             forState:UIControlStateSelected];
    //color for text in searchfield
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:customBlueColor(),
                                                                                                 NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:15.0f]}];
    
    //color for placeholder in searchfield
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:customBlueColor()];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setClearButtonMode:UITextFieldViewModeNever];
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : customBlueColor(),
                                                            NSFontAttributeName:[UIFont fontWithName:@"simplonmono-regular" size:16.0f]}
                                                forState:UIControlStateNormal];
    
    [self configTabbarToplineLight];
}

+ (void)configTabbarToplineLight {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 1, 1)];
    view.backgroundColor = lightTabBarTopLineColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:img];
}

@end
