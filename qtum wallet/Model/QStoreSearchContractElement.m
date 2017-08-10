//
//  QStoreSearchContractElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreSearchContractElement.h"

@interface QStoreSearchContractElement()

@property (nonatomic) NSArray<NSString *> *tags;

@end

@implementation QStoreSearchContractElement

- (instancetype)initWithIdString:(NSString *)idString
                            name:(NSString *)name
                     priceString:(NSString *)priceString
                        countBuy:(NSNumber *)countBuy
                  countDownloads:(NSNumber *)countDownloads
                       createdAt:(NSDate *)createdAt
                      typeString:(NSString *)typeString
                            tags:(NSArray<NSString *> *)tags {
    
    self = [super initWithIdString:idString name:name
                       priceString:priceString
                          countBuy:countBuy
                    countDownloads:countDownloads
                         createdAt:createdAt
                        typeString:typeString];
    if (self) {
        _tags = tags;
    }
    return self;
}

+ (QStoreSearchContractElement *)createSearchFromDictionary:(NSDictionary *)dictionary {
    
    if (!dictionary || ![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    QStoreShortContractElement *element = [QStoreShortContractElement createFromDictionary:dictionary];
    
    NSArray *tags = [dictionary objectForKey:@"tags"];
    
    return [[QStoreSearchContractElement alloc] initWithIdString:element.idString
                                                            name:element.name
                                                     priceString:element.priceString
                                                        countBuy:element.countBuy
                                                  countDownloads:element.countDownloads
                                                       createdAt:element.createdAt
                                                      typeString:element.typeString
                                                            tags:tags];
}

@end
