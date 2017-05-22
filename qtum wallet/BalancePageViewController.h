//
//  BalancePageViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paginationable.h"
#import "WalletCoordinator.h"

@interface BalancePageViewController : UIPageViewController 

@property (strong, nonatomic) NSArray <UIViewController <Paginationable>*>* controllers;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> coordinatorDelegate;

@end
