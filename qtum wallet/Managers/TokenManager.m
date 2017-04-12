//
//  TokenManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 12.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenManager.h"

@interface TokenManager ()

@property (strong, nonatomic) NSMutableDictionary* smartContractPretendents;

@end

@implementation TokenManager

+ (instancetype)sharedInstance
{
    static TokenManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

-(NSMutableDictionary*)smartContractPretendents{
    
    if (!_smartContractPretendents) {
        _smartContractPretendents = @{}.mutableCopy;
    }
    return _smartContractPretendents;
}

-(void)load{
    
}

-(void)addSmartContractPretendent:(BTCTransaction*) transaction{
    [self.smartContractPretendents setObject:transaction forKey:transaction.transactionID];
}

-(void)deleteSmartContractPretendent:(BTCTransaction*) transaction{
    [self.smartContractPretendents removeObjectForKey:transaction.transactionID];
}

-(void)updateSmartContractPretendent:(BTCTransaction*) transaction{
    //TODO update Token Transaction
}

@end
