//
//  HistoryDataStorage.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "HistoryDataStorage.h"

NSString *const HistoryUpdateEvent = @"HistoryUpdateEvent";

@interface HistoryDataStorage ()

@property (strong, nonatomic) NSMutableArray<HistoryElement*>* historyPrivate;

@end

@implementation HistoryDataStorage


#pragma mark - Private Methods

-(void)notificateChangeHistory{
    [self.spendableOwner historyDidChange];
}

#pragma mark Public Methods

- (void)setHistory:(NSArray<HistoryElement*>*) history{
    self.historyPrivate = [[history reverseObjectEnumerator] allObjects].mutableCopy;
    [self notificateChangeHistory];
}

- (NSArray<HistoryElement*>*)getHistory{
    return [_historyPrivate copy];
}

- (void)setHistoryItem:(HistoryElement*) item{
    NSUInteger  index = [self.historyPrivate indexOfObjectPassingTest:^BOOL(HistoryElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualElementWithoutConfimation:item]) {
            return YES;
        }
        return NO;
    }];

    if (index < self.historyPrivate.count) {
        self.historyPrivate[index] = item;
    } else {
        [self.historyPrivate insertObject:item atIndex:0];
    }
    [self notificateChangeHistory];
}

- (void)deleteHistoryItem:(HistoryElement*) item{
    [self.historyPrivate removeObject:item];
    [self notificateChangeHistory];
}

- (HistoryElement*)updateHistoryItem:(HistoryElement*) item{
    //TODO
    if ([self.historyPrivate containsObject:item]) {
        
    }
    [self notificateChangeHistory];
    return nil;
}

- (void)addHistoryElements:(NSArray<HistoryElement*>*) elements{
    
    [self.historyPrivate addObjectsFromArray:[[elements reverseObjectEnumerator] allObjects]];
    [self notificateChangeHistory];
}


@end
