//
//  QStoreShortContractElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreShortContractElement.h"

@interface QStoreShortContractElement()

@property (nonatomic) NSString *idString;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *priceString;
@property (nonatomic) NSNumber *countBuy;
@property (nonatomic) NSNumber *countDownloads;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) NSString *typeString;
@property (nonatomic) CategoryElementType type;

@end

@implementation QStoreShortContractElement

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString {
    
    self = [super init];
    if (self) {
        _idString = idString;
        _name = name;
        _priceString = priceString;
        _countBuy = countBuy;
        _countDownloads = countDownloads;
        _createdAt = createdAt;
        _typeString = typeString;
        _type = [self getTypeByString:typeString];
    }
    return self;
}

- (CategoryElementType)getTypeByString:(NSString *)stringType {
    if ([stringType isEqualToString:@"crowdsale"]) {
        return CategoryElementTypeCrowdsale;
    }
    
    if ([stringType isEqualToString:@"token"]) {
        return CategoryElementTypeToken;
    }
    
    return CategoryElementTypeUnknown;
}

- (NSString *)getImageNameByType {
    switch (self.type) {
        case CategoryElementTypeToken:
            return @"ic-supertoken";
        case CategoryElementTypeCrowdsale:
            return @"ic-crowdsale";
        default:
            return @"ic-smart_contract";
    }
}

+ (QStoreShortContractElement *)createFromDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *idString = [dictionary objectForKey:@"_id"];
    NSString *name = [dictionary objectForKey:@"name"];
    NSString *priceString = [dictionary objectForKey:@"price"];
    NSNumber *countBuy = [dictionary objectForKey:@"count_buy"];
    NSNumber *countDownloads = [dictionary objectForKey:@"count_downloads"];
    NSString *createdAtString = [dictionary objectForKey:@"created_at"];
    NSString *typeString = [dictionary objectForKey:@"type"];
    
    //TODO: Check
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    NSDate *createdAt = [formatter dateFromString:createdAtString];
    
    return [[QStoreShortContractElement alloc] initWithIdString:idString
                                                      name:name
                                               priceString:priceString
                                                  countBuy:countBuy
                                            countDownloads:countDownloads
                                                 createdAt:createdAt
                                                typeString:typeString];
}

@end
