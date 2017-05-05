//
//  Appearance.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "Appearance.h"

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
//    [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UITabBar class]]] setTintColor:[UIColor colorWithRed:83/255. green:97/255. blue:115/255. alpha:1]];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{[UIColor colorWithRed:83/255. green:97/255. blue:115/255. alpha:1] : NSForegroundColorAttributeName}
//                                             forState:UIControlStateNormal];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{[UIColor colorWithRed:54/255. green:185/255. blue:200/255. alpha:1] : NSForegroundColorAttributeName}
//                                             forState:UIControlStateSelected];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{
//                                                                                                 NSFontAttributeName: [UIFont fontWithName:@"MyriadPro-Regular" size:14],
//                                                                                                 }];
}

@end
