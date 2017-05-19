//
//  BalancePageViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paginationable.h"

@interface BalancePageViewController : UIPageViewController 

@property (strong, nonatomic) NSArray <UIViewController <Paginationable>*>* controllers;

@end
