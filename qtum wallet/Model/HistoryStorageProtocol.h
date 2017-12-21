//
//  HistoryStorageProtocol.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Spendable;
@protocol HistoryElementProtocol;

@protocol HistoryStorageProtocol <NSObject>

@property (strong, nonatomic, readonly) NSMutableArray<HistoryElement *> *historyPrivate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) id <Spendable> spendableOwner;

- (void)addHistoryElements:(NSArray<id <HistoryElementProtocol>> *) elements;

- (void)setHistoryItem:(id <HistoryElementProtocol>) item;

- (void)deleteHistoryItem:(id <HistoryElementProtocol>) item;

- (HistoryElement *)updateHistoryItem:(id <HistoryElementProtocol>) item;

- (void)setHistory:(NSArray<id <HistoryElementProtocol>> *) history;

@end
