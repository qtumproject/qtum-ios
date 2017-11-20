//
//  HistoryDataStorage.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HistoryElement.h"

@protocol Spendable;

extern NSString *const HistoryUpdateEvent;

@interface HistoryDataStorage : NSObject

@property (strong, nonatomic, readonly) NSMutableArray<HistoryElement *> *historyPrivate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) id <Spendable> spendableOwner;

- (void)addHistoryElements:(NSArray<HistoryElement *> *) elements;

- (void)setHistoryItem:(HistoryElement *) item;

- (void)deleteHistoryItem:(HistoryElement *) item;

- (HistoryElement *)updateHistoryItem:(HistoryElement *) item;

- (void)setHistory:(NSArray<HistoryElement *> *) history;

@end
