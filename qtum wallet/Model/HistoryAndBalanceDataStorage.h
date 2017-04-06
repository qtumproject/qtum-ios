//
//  HistoryDataStorage.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

extern NSString *const HistoryUpdateEvent;
extern NSString *const BalanceUpdateEvent;


@interface HistoryAndBalanceDataStorage : NSObject

@property (assign,nonatomic) CGFloat balance;
@property (strong, nonatomic,readonly) NSMutableArray<HistoryElement*>* historyPrivate;

- (void)addHistoryElements:(NSArray<HistoryElement*>*) elements;
- (void)setHistoryItem:(HistoryElement*) item;
- (void)deleteHistoryItem:(HistoryElement*) item;
- (HistoryElement*)updateHistoryItem:(HistoryElement*) item;
- (void)setHistory:(NSArray<HistoryElement*>*) history;


+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
