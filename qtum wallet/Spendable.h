//
//  Spendable.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Managerable.h"
#import "HistoryElementProtocol.h"
#import "HistoryDataStorage.h"
@class JKBigDecimal;

@protocol Managerable;

@protocol Spendable <NSObject>

@property (copy, nonatomic) NSString* name;
@property (strong, nonatomic) JKBigDecimal *balance;
@property (strong, nonatomic) JKBigDecimal *unconfirmedBalance;
@property (strong, nonatomic) HistoryDataStorage* historyStorage;
@property (copy, nonatomic)NSString* mainAddress;
@property (copy, nonatomic)NSString* symbol;
@property (weak, nonatomic)id <Managerable> manager;

-(void)updateBalanceWithHandler:(void(^)(BOOL success)) complete;
-(void)updateWithHandler:(void(^)(BOOL success)) complete;
-(void)updateHistoryWithHandler:(void(^)(BOOL success)) complete andPage:(NSInteger) page;
-(void)loadToMemory;
-(void)historyDidChange;

@end
