//
//  TabBarCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"
#import "TabBarController.h"


@protocol TabBarCoordinatorDelegate <NSObject>

@required

-(void)createPaymentFromWalletScanWithDict:(NSDictionary*) dict;

@end

@protocol ApplicationCoordinatorDelegate;

@interface TabBarCoordinator : BaseCoordinator <Coordinatorable,TabBarCoordinatorDelegate, TabbarOutputDelegate>

@property (weak,nonatomic) id <ApplicationCoordinatorDelegate> delegate;

- (instancetype)initWithTabBarController:(UITabBarController<TabbarOutput>*)tabBarController;

- (void)startFromSendWithAddress:(NSString*)address andAmount:(NSString*) amount;
- (void)showControllerByIndex:(NSInteger)index;
- (UIViewController *)getViewControllerByIndex:(NSInteger)index;

@end
