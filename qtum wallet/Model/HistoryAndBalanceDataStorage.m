//
//  HistoryDataStorage.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "HistoryAndBalanceDataStorage.h"
#import "HistoryElement.h"


NSString *const HistoryUpdateEvent = @"HistoryUpdateEvent";
NSString *const BalanceUpdateEvent = @"BalanceUpdateEvent";



@interface HistoryAndBalanceDataStorage ()

@property (strong, nonatomic) NSMutableArray<HistoryElement*>* historyPrivate;

@end

@implementation HistoryAndBalanceDataStorage

#pragma mark - Init

+ (instancetype)sharedInstance {
    static HistoryAndBalanceDataStorage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    if (self != nil) {}
    return self;
}

#pragma mark - Private Methods

-(void)notificateChangeHistory{
    [[NSNotificationCenter defaultCenter] postNotificationName:HistoryUpdateEvent object:nil userInfo:nil];
}

-(void)notificateChangeBalance{
    [[NSNotificationCenter defaultCenter] postNotificationName:BalanceUpdateEvent object:nil userInfo:nil];
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
        [self.historyPrivate replaceObjectAtIndex:index withObject:item];
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
    if ([self.historyPrivate containsObject:item]) {
        
    }
    [self notificateChangeHistory];
    return nil;
}

- (void)addHistoryElements:(NSArray<HistoryElement*>*) elements{
//    self.historyPrivate = [[elements arrayByAddingObjectsFromArray:self.historyPrivate] mutableCopy];
    [self.historyPrivate addObjectsFromArray:[[elements reverseObjectEnumerator] allObjects]];
    [self notificateChangeHistory];
}

-(void)setBalance:(CGFloat) balance{
    _balance = balance;
    [self notificateChangeBalance];
}



@end
