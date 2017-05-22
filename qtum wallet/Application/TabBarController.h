//
//  TabBarController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBarCoordinator;

@protocol TabBarCoordinatorDelegate;

@interface TabBarController : UITabBarController

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> coordinatorDelegate;

-(void)selectSendControllerWithAdress:(NSString*)adress andValue:(NSString*)amount;

@end
