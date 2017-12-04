//
//  BalancePageViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BalancePageOutput.h"
#import "Presentable.h"

@interface BalancePageViewController : BaseViewController <BalancePageOutput, Presentable>

@property (copy, nonatomic) NSArray <UIViewController <Paginationable> *> *controllers;
@property (nonatomic, readonly) NSInteger currentIndex;
@property (nonatomic, readonly) UIView *container;

- (void)changeCurrentIndex:(NSInteger) index;

@end
