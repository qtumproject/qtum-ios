//
//  TabBarController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabbarOutput.h"
#import "TabbarOutputDelegate.h"

@interface TabBarController : UITabBarController <TabbarOutput>

@property (weak,nonatomic) id <TabbarOutputDelegate> outputDelegate;
@property (assign,nonatomic) BOOL isReload;

-(void)storeSendReference:(UIViewController*)sendController;

@end
