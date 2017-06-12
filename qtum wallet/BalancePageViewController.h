//
//  BalancePageViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paginationable.h"
#import "WalletCoordinator.h"

@interface BalancePageViewController : UIPageViewController 

@property (strong, nonatomic) NSArray <UIViewController <Paginationable>*>* controllers;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> coordinatorDelegate;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToRootIfNeededAnimated:(BOOL)animated;
- (void)setScrollingToTokensAvailableIfNeeded;
- (void)setScrollEnable:(BOOL)enable;

@end
