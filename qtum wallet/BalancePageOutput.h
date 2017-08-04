//
//  BalancePageOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paginationable.h"

@protocol BalancePageOutput <NSObject>

@property (copy, nonatomic) NSArray <UIViewController <Paginationable>*>* controllers;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
- (void)scrollToRootIfNeededAnimated:(BOOL)animated;
- (void)setScrollingToTokensAvailableIfNeeded;
- (void)setScrollEnable:(BOOL)enable;
- (void)setPageControllHidden:(BOOL) hidden;


@end
