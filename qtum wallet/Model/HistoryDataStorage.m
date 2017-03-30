//
//  HistoryDataStorage.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "HistoryDataStorage.h"
#import "HistoryElement.h"

@interface HistoryDataStorage ()

@property (strong, nonatomic) NSMutableArray<HistoryElement*>* historyPrivate;

@end

@implementation HistoryDataStorage

#pragma mark - Init

+ (instancetype)sharedInstance
{
    static HistoryDataStorage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) {

    }
    return self;
}

#pragma mark Public Methods

- (void)setHistory:(NSArray<HistoryElement*>*) history{
    self.historyPrivate = history.mutableCopy;
}

- (NSArray<HistoryElement*>*)getHistory{
    return [_historyPrivate copy];
}

- (void)setHistoryItem:(HistoryElement*) item{
    [self.historyPrivate addObject:item];
}

- (void)deleteHistoryItem:(HistoryElement*) item{
    [self.historyPrivate removeObject:item];
}

- (HistoryElement*)updateHistoryItem:(HistoryElement*) item{
    return nil;
}


@end
