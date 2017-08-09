//
//  QStoreFullContractElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreFullContractElement.h"

@interface QStoreFullContractElement()

@property (nonatomic) NSString *contractDescription;
@property (nonatomic) NSString *publisherAddress;
@property (nonatomic) NSString *size;
@property (nonatomic) NSString *completedOn;
@property (nonatomic) NSArray<NSString *> *tags;
@property (nonatomic) BOOL withSourseCode;

@end

@implementation QStoreFullContractElement

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
                  withSourseCode:(BOOL)withSourseCode {
    
    self = [super initWithIdString:idString name:name priceString:priceString countBuy:countBuy countDownloads:countDownloads createdAt:createdAt typeString:typeString];
    if (self) {
        _contractDescription = contractDescription;
        _publisherAddress = publisherAddress;
        _size = size;
        _completedOn = completedOn;
        _tags = tags;
        _withSourseCode = withSourseCode;
    }
    return self;
}

+ (QStoreFullContractElement *)createFullFromDictionary:(NSDictionary *)dictionary {
    
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
    
    NSString *contractDescription = [dictionary objectForKey:@"description"];
    NSString *publisherAddress = [dictionary objectForKey:@"publisher_address"];
    NSString *size = [dictionary objectForKey:@"size"];
    NSString *completedOn = [dictionary objectForKey:@"completed_on"];
    NSArray<NSString *> *tags = [dictionary objectForKey:@"tags"];
    BOOL withSourseCode = [[dictionary objectForKey:@"with_source_code"] boolValue];
    
    return [[QStoreFullContractElement alloc] initWithIdString:idString
                                                          name:name
                                                   priceString:priceString
                                                      countBuy:countBuy
                                                countDownloads:countDownloads
                                                     createdAt:createdAt
                                                    typeString:typeString
                                           contractDescription:contractDescription
                                              publisherAddress:publisherAddress
                                                          size:size
                                                   completedOn:completedOn
                                                          tags:tags
                                                withSourseCode:withSourseCode];
}

@end
