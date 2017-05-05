//
//  Appearance.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "Appearance.h"
#import "UIImage+Extension.h"

@implementation Appearance

+(void)setUp{
    [[SVProgressHUD appearance] setDefaultStyle:SVProgressHUDStyleCustom];
    [[SVProgressHUD appearance] setForegroundColor:[UIColor colorWithRed:104/255.0f green:195/255.0f blue:207/255.0f alpha:1.0f]];
    [[SVProgressHUD appearance] setBackgroundColor:[UIColor whiteColor]];
    [[SVProgressHUD appearance] setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SVProgressHUD appearance] setMinimumDismissTimeInterval:1];
    
    //[[UITextField appearance] setTintColor:[UIColor whiteColor]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Regular" size:11.0f]}
//                                          forState:UIControlStateNormal];
//    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:customBlueColor()];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{customBlueColor() : NSForegroundColorAttributeName}
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{customBlueColor() : NSForegroundColorAttributeName}
//                                             forState:UIControlStateSelected];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
//                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"MyriadPro-Regular" size:14],
//
    [self configTabbarUndeline];
}

+(void)configTabbarUndeline {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake([UITabBar appearance].frame.origin.x,[UITabBar appearance].frame.origin.y, 50, 56)];
    
    UIImageView *border = [[UIImageView alloc]initWithFrame:CGRectMake(view.frame.origin.x,view.frame.size.height-6, 50, 6)];
    border.backgroundColor = customBlueColor();
    [view addSubview:border];
    UIImage *img = [UIImage changeViewToImage:view];
    [[UITabBar appearance] setSelectionIndicatorImage:img];
    [[UITabBar appearance] setTintColor: customBlueColor()];
}


@end
