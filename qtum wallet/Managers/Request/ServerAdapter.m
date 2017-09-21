//
//  ServerAdapter.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ServerAdapter.h"
#import "NSNumber+Comparison.h"

@implementation ServerAdapter

- (id)adaptiveDataForHistory:(id) data {
    
    if ([data isKindOfClass:[NSArray class]]) {
        return data;
    } else if ([data[@"items"] isKindOfClass:[NSArray class]]){
        return data[@"items"];
    } else {
        NSAssert([data isKindOfClass:[NSArray class]], @"data from history must constain array of items");
    }
    return nil;
}

- (id)adaptiveDataForOutputs:(id) data{
    return data;
}

- (NSNumber*)adaptiveDataForFeePerKb:(id) data {
    
    NSNumber* fee = data[@"fee_per_kb"];
    if ([fee isKindOfClass:[NSNumber class]]) {
        return fee;
    }
    return nil;
}

- (id)adaptiveDataForBalance:(id) balances {
    
    if ([balances isKindOfClass:[NSDictionary class]]) {
        
        NSNumber* balance = balances[@"balance"];
        NSNumber* unconfirmedBalance = balances[@"unconfirmedBalance"];
        NSDecimalNumber* dev = [[NSDecimalNumber alloc] initWithInt:100000000];
        
        return @{@"balance" : [balance.decimalNumber decimalNumberByDividingBy:dev],
                 @"unconfirmedBalance" : [unconfirmedBalance.decimalNumber decimalNumberByDividingBy:dev]};
    }
    return nil;
}


@end
