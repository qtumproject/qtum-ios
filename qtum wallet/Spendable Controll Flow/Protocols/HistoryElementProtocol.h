//
//  HistoryElementProtocol.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMBigNumber.h"

@protocol HistoryElementProtocol <NSObject>

@property (copy, nonatomic) NSString *address;
@property (strong, nonatomic) QTUMBigNumber *amount;
@property (copy, nonatomic) NSString *amountString;
@property (copy, nonatomic) NSString *txHash;
@property (strong, nonatomic) NSNumber *dateNumber;
@property (copy, nonatomic) NSString *shortDateString;
@property (copy, nonatomic) NSString *fullDateString;

@property (strong, nonatomic) NSMutableArray *fromAddreses;
@property (strong, nonatomic) NSMutableArray *toAddresses;
@property (assign, nonatomic) BOOL send;
@property (assign, nonatomic) BOOL confirmed;
@property (copy, nonatomic) NSString* currency;

- (BOOL)isEqualElementWithoutConfimation:(id <HistoryElementProtocol>) object;
- (void)setupWithObject:(id) object;
- (NSString *)formattedDateStringSinceCome;
- (NSDictionary *)dictionaryFromElementForWatch;
    
@optional
@property (assign, nonatomic) BOOL isSmartContractCreater;

@end
