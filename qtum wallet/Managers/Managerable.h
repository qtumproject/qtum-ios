//
//  Managerable.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spendable.h"

@protocol Spendable;

@protocol Managerable <NSObject>

-(void)spendableDidChange:(id <Spendable>) object;
-(void)updateSpendableObject:(id <Spendable>) object;
-(void)updateSpendablesBalansesWithObject:(id) updateObject;
-(void)updateSpendablesHistoriesWithObject:(id) updateObject;
-(void)updateBalanceOfSpendableObject:(id <Spendable>) object withHandler:(void(^)(BOOL success)) complete;
-(void)updateHistoryOfSpendableObject:(id <Spendable>) object withHandler:(void(^)(BOOL success)) complete andPage:(NSInteger) page;
-(void)loadSpendableObjects;
-(void)saveSpendableObjects;
-(void)startObservingForSpendable:(id <Spendable>) spendable;
-(void)stopObservingForSpendable:(id <Spendable>) spendable;
-(void)startObservingForAllSpendable;
-(void)stopObservingForAllSpendable;
-(void)clear;

@end
