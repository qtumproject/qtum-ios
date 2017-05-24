//
//  TabBarController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarCoordinator;

@protocol TabBarCoordinatorDelegate;

@interface TabBarController : UITabBarController

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> coordinatorDelegate;
@property (assign,nonatomic) BOOL isReload;

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount;

@end
