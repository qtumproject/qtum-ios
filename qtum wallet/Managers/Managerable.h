//
//  Managerable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spendable.h"

@protocol Managerable <NSObject>

-(void)updateSpendableObject:(id <Spendable>) object;
-(void)updateSpendableWithObject:(id) updateObject;
-(void)updateBalanceOfSpendableObject:(id <Spendable>) object;
-(void)updateHistoryOfSpendableObject:(id <Spendable>) object;
-(void)loadSpendableObjects;
-(void)saveSpendableObjects;
-(void)startObservingForSpendable;
-(void)stopObservingForSpendable;

@end
