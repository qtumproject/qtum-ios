//
//  WalletManagerRequestAdapter.m
//  qtum wallet
//
//  Created by Никита Федоренко on 20.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletManagerRequestAdapter.h"
#import "HistoryElement.h"

@implementation WalletManagerRequestAdapter

- (void)getBalanceForAddreses:(NSArray *)keyAddreses
           withSuccessHandler:(void(^)(double responseObject))success
            andFailureHandler:(void(^)(NSError *error, NSString* message))failure {
    
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getUnspentOutputsForAdreses:keyAddreses isAdaptive:YES successHandler:^(id responseObject) {
        success([weakSelf calculateBalance:responseObject]);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getHistoryForAddresses:(NSArray *)keyAddreses andParam:(NSDictionary*) param withSuccessHandler:(void(^)(NSArray *responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure{
    __weak typeof(self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getHistoryWithParam:param andAddresses:keyAddreses successHandler:^(id responseObject) {
        NSArray <HistoryElement *>* history = [weakSelf createHistoryElements:responseObject];
        success(history);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}


- (NSArray *)createHistoryElements:(NSArray *)responseObject {
    
    NSArray* responseObjectLocal = [[responseObject reverseObjectEnumerator] allObjects];
    NSMutableArray<HistoryElement*> *array = [NSMutableArray new];
    
    for (NSDictionary *dictionary in responseObjectLocal) {
        HistoryElement *element = [self createHistoryElement:dictionary];
        [array addObject:element];
    }
    
    return  array;
}

- (HistoryElement *)createHistoryElement:(NSDictionary *)dictionary{
    
    HistoryElement *element = [HistoryElement new];
    [element setupWithObject:dictionary];
    [[TokenManager sharedInstance] checkSmartContract:element];
    return  element;
}

- (double)calculateBalance:(NSArray *)responseObject {
    
    double balance = 0;
    
    for (NSDictionary *dictionary in responseObject) {
        double amount = [dictionary[@"amount"] doubleValue];
        balance += amount;
    }
    
    return balance;
}

@end
