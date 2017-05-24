//
//  Wallet.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 15.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spendable.h"

@class HistoryDataStorage;
@class Wallet;

@interface Wallet : NSObject <Spendable>

- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin;
- (instancetype)initWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray *)seedWords;

@property (copy, nonatomic) NSString* name;
@property (assign, nonatomic) CGFloat balance;
@property (assign, nonatomic) CGFloat unconfirmedBalance;
@property (strong, nonatomic)NSArray <HistoryElementProtocol>*historyArray;
@property (copy, nonatomic)NSString* mainAddress;
@property (copy, nonatomic)NSString* symbol;
@property (weak, nonatomic)id <Managerable> manager;
@property (nonatomic,copy) NSString *pin;
@property (nonatomic, readonly, copy) NSArray *seedWords;
@property (nonatomic, readonly) NSInteger countOfUsedKeys;
@property (strong, nonatomic) HistoryDataStorage* historyStorage;

- (BTCKey *)getLastRandomKeyOrRandomKey;
- (BTCKey *)getRandomKey;
- (BTCKey *)getKeyAtIndex:(NSUInteger)index;
- (NSArray *)getAllKeys;
- (NSString *)getWorldsString;
- (NSArray <NSString*>*)getAllKeysAdreeses;

@end
