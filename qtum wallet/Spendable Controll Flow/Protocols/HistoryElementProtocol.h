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
@property (copy, nonatomic) NSString *transactionHash;
@property (strong, nonatomic) NSNumber *dateNumber;
@property (copy, nonatomic) NSString *shortDateString;
@property (copy, nonatomic) NSString *fullDateString;
@property (assign, nonatomic) BOOL hasReceipt;
@property (strong, nonatomic) NSArray *fromAddresses;
@property (strong, nonatomic) NSArray *toAddresses;
@property (assign, nonatomic) BOOL send;
@property (assign, nonatomic) BOOL confirmed;
@property (assign, nonatomic) BOOL internal;
@property (assign, nonatomic) BOOL contracted;
@property (copy, nonatomic) NSString* currency;
@property (assign, nonatomic) NSInteger blockNumber;
@property (copy, nonatomic) NSString* blockHash;


- (BOOL)isEqualElementWithoutConfimation:(id <HistoryElementProtocol>) object;
- (void)setupWithObject:(id) object;
- (NSString *)formattedDateStringSinceCome;
- (NSDictionary *)dictionaryFromElementForWatch;
    
@optional
@property (assign, nonatomic) BOOL isSmartContractCreater;
@property (strong, nonatomic) QTUMBigNumber *fee;
@property (strong, nonatomic) NSString *decimals;

@end
