//
//  HistoryElementProtocol.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HistoryElementProtocol <NSObject>

@property (copy,    nonatomic) NSString *address;
@property (copy,    nonatomic) NSNumber *amount;
@property (copy,    nonatomic) NSString *amountString;
@property (copy,    nonatomic) NSString *txHash;
@property (strong,  nonatomic) NSNumber *dateNumber;
@property (copy,    nonatomic) NSString *shortDateString;
@property (copy,    nonatomic) NSString *fullDateString;
@property (assign,  nonatomic) BOOL send;
@property (assign,  nonatomic) BOOL confirmed;
@property (assign,  nonatomic) BOOL isSmartContractCreater;
@property (strong,  nonatomic) NSMutableArray *fromAddreses;
@property (strong,  nonatomic) NSMutableArray *toAddresses;

-(BOOL)isEqualElementWithoutConfimation:(id <HistoryElementProtocol>)object;
-(void)setupWithObject:(id)object;

@end
