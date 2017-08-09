//
//  QStoreShortContractElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CategoryElementType) {
    CategoryElementTypeCrowdsale,
    CategoryElementTypeToken,
    CategoryElementTypeUnknown
};

@interface QStoreShortContractElement : NSObject

@property (nonatomic, readonly) NSString *idString;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *priceString;
@property (nonatomic, readonly) NSNumber *countBuy;
@property (nonatomic, readonly) NSNumber *countDownloads;
@property (nonatomic, readonly) NSDate *createdAt;
@property (nonatomic, readonly) NSString *typeString;
@property (nonatomic, readonly) CategoryElementType type;

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString;

- (NSString *)getImageNameByType;

+ (QStoreShortContractElement *)createFromDictionary:(NSDictionary *)dictionary;

@end
