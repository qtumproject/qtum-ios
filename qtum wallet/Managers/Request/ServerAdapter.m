//
//  ServerAdapter.m
//  qtum wallet
//
//  Created by Никита Федоренко on 21.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ServerAdapter.h"

@implementation ServerAdapter

- (id)adaptiveDataForHistory:(id) data{
    return data;
//    NSMutableArray* newDataArray = @[].mutableCopy;
//    if ([data isKindOfClass:[NSArray class]]) {
//        for (NSDictionary* dict in data) {
//            NSMutableDictionary* newDataObject = [NSMutableDictionary dictionaryWithDictionary:dict];
//            if (newDataObject[@"amount"] && ![newDataObject[@"amount"] isKindOfClass:[NSNull class]]) {
//                NSInteger amount = [newDataObject[@"amount"] integerValue];
//                // div to satoshi
//                amount /= 100000000;
//                [newDataObject setObject:@(amount) forKey:@"amount"];
//            }
//            [newDataArray addObject:[newDataObject copy]];
//        }
//    }
//    
//    return newDataArray.count > 0 ? newDataArray : data;
}

- (id)adaptiveDataForOutputs:(id) data{
    return [self adaptiveDataForHistory:data];
}

@end
