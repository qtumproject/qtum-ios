//
//  QStoreFullContractElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreShortContractElement.h"

@interface QStoreFullContractElement : QStoreShortContractElement

@property (nonatomic, readonly) NSString *contractDescription;
@property (nonatomic, readonly) NSString *publisherAddress;
@property (nonatomic, readonly) NSString *size;
@property (nonatomic, readonly) NSString *completedOn;
@property (nonatomic, readonly) NSArray<NSString *> *tags;
@property (nonatomic, readonly) BOOL withSourseCode;

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString
             contractDescription:(NSString *)contractDescription
                publisherAddress:(NSString *)publisherAddress
                            size:(NSString *)size
                     completedOn:(NSString *)completedOn
                            tags:(NSArray<NSString *> *)tags
                  withSourseCode:(BOOL)withSourseCode;

+ (QStoreFullContractElement *)createFullFromDictionary:(NSDictionary *)dictionary;

@end
