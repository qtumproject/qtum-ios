//
//  WatchWallet.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WatchWallet.h"

@implementation WatchWallet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setupFromDictionary:dictionary];
    }
    return self;
}

- (void)setupFromDictionary:(NSDictionary *)dictionary {
    self.address = dictionary[@"address"];
    self.availableBalance = dictionary[@"availableBalance"];
    self.unconfirmedBalance = dictionary[@"unconfirmedBalance"];
    self.imageData = dictionary[@"image"];
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    for (NSDictionary *dic in dictionary[@"history"]) {
        WatchHistoryElement *element = [[WatchHistoryElement alloc] initWithDictionary:dic];
        [mutableArray addObject:element];
    }
    self.history = mutableArray;
}

@end
