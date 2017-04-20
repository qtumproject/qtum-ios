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

@interface HistoryDataStorage : NSObject

@property (strong, nonatomic,readonly) NSMutableArray<HistoryElement*>* historyPrivate;
@property (assign, nonatomic) NSInteger pageIndex;

- (void)addHistoryElements:(NSArray<HistoryElement*>*) elements;
- (void)setHistoryItem:(HistoryElement*) item;
- (void)deleteHistoryItem:(HistoryElement*) item;
- (HistoryElement*)updateHistoryItem:(HistoryElement*) item;
- (void)setHistory:(NSArray<HistoryElement*>*) history;

@end
