//
//  QStoreContractElement.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 11.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CategoryElementType) {
    CategoryElementTypeCrowdsale,
    CategoryElementTypeToken,
    CategoryElementTypeUnknown
};

typedef NS_ENUM(NSInteger, CategoryElementState) {
    CategoryElementStateCategory,
    CategoryElementStateSearch,
    CategoryElementStateFull
};

@interface QStoreContractElement : NSObject

// Short
@property (nonatomic, readonly) CategoryElementState elementState;
@property (nonatomic, readonly) NSString *idString;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *priceString;
@property (nonatomic, readonly) NSNumber *countBuy;
@property (nonatomic, readonly) NSNumber *countDownloads;
@property (nonatomic, readonly) NSDate *createdAt;
@property (nonatomic, readonly) NSString *typeString;
@property (nonatomic, readonly) CategoryElementType type;

// Full
@property (nonatomic, readonly) NSString *contractDescription;
@property (nonatomic, readonly) NSString *publisherAddress;
@property (nonatomic, readonly) NSString *size;
@property (nonatomic, readonly) NSString *completedOn;
@property (nonatomic, readonly) NSArray<NSString *> *tags;
@property (nonatomic, readonly) BOOL withSourseCode;
@property (nonatomic) NSString *abiString;

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString;

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

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString
                            tags:(NSArray<NSString *> *)tags;


+ (QStoreContractElement *)createFromCategoryDictionary:(NSDictionary *)dictionary;
+ (QStoreContractElement *)createFromFullDictionary:(NSDictionary *)dictionary;
+ (QStoreContractElement *)createFromSearchDictionary:(NSDictionary *)dictionary;

- (NSString *)getImageNameByType;

- (void)updateWithFullDictionary:(NSDictionary *)dictionary;
- (void)updateWithSearchDictionary:(NSDictionary *)dictionary;

@end
