//
//  NewsDataProvider.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDataProvider.h"
#import "NetworkingService.h"

@interface NewsDataProvider ()

@property (strong, nonatomic) NetworkingService* networkService;

@end

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
        _networkService = [[NetworkingService alloc] initWithBaseUrl:@""];
    }
    return self;
}

-(void)authorise {
    
    [self.networkService requestWithType:GET path:@"" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString * _Nullable message) {
        
    }];
}

@end
