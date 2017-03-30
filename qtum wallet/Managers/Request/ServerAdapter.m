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

@end
