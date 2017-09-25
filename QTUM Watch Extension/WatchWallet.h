//
//  WatchWallet.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WatchHistoryElement.h"

@interface WatchWallet : NSObject

@property (nonatomic) NSString *address;
@property (nonatomic) NSNumber *availableBalance;
@property (nonatomic) NSNumber *unconfirmedBalance;
@property (nonatomic) NSData *imageData;
@property (nonatomic) NSArray<WatchHistoryElement *> *history;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
