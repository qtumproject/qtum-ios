//
//  HistoryElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryElement : NSObject

@property (nonatomic) NSString *address;
@property (nonatomic) NSNumber *amount;
@property (nonatomic) NSString *amountString;
@property (nonatomic) NSNumber *dateNumber;
@property (nonatomic) NSString *dateString;
@property (nonatomic) BOOL send;

@end
