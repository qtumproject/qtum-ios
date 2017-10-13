//
//  NewsDataProvider.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDataProvider.h"

@implementation NewsDataProvider

+ (instancetype)sharedInstance {
    
    static NewsDataProvider *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        [self authorise];
    }
    return self;
}

-(void)authorise {
    
}

@end
