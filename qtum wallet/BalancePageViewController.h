//
//  BalancePageViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalancePageOutput.h"
#import "Presentable.h"

@interface BalancePageViewController : UIPageViewController  <BalancePageOutput, Presentable>

@property (copy, nonatomic) NSArray <UIViewController <Paginationable>*>* controllers;
@property (nonatomic, readonly) NSInteger currentIndex;

- (void)changeCurrentIndex:(NSInteger)index;

@end
