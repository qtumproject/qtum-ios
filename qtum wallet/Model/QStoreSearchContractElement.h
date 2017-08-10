//
//  QStoreSearchContractElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreShortContractElement.h"

@interface QStoreSearchContractElement : QStoreShortContractElement

@property (nonatomic, readonly) NSArray<NSString *> *tags;

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString
                            tags:(NSArray<NSString *> *)tags;

+ (QStoreSearchContractElement *)createSearchFromDictionary:(NSDictionary *)dictionary;

@end
