//
//  HistoryElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryElement : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, copy) NSString *amountString;
@property (nonatomic, copy) NSString *txHash;
@property (nonatomic) NSNumber *dateNumber;
@property (nonatomic, copy) NSString *shortDateString;
@property (nonatomic, copy) NSString *fullDateString;
@property (nonatomic) BOOL send;
@property (assign, nonatomic) BOOL confirmed;
@property (assign, nonatomic) BOOL isSmartContractCreater;
@property (strong, nonatomic) NSMutableArray *fromAddreses;
@property (strong, nonatomic) NSMutableArray *toAddresses;

-(BOOL)isEqualElementWithoutConfimation:(HistoryElement*)object;
-(void)setupWithObject:(id)object;
-(NSDictionary *)dictionaryFromElementForWatch;

@end
