//
//  TabbarOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TabbarOutputDelegate <NSObject>

@required
-(void)didSelecteNewsTabWithController:(UIViewController*)controller;
-(void)didSelecteSendTabWithController:(UIViewController*)controller;
-(void)didSelecteProfileTabWithController:(UIViewController*)controller;
-(void)didSelecteWalletTabWithController:(UIViewController*)controller;

@end
