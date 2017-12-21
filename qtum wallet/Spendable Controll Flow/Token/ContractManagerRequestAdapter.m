//
//  ContractManagerRequestAdapter.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractManagerRequestAdapter.h"
#import "TokenHistoryElement.h"

@implementation ContractManagerRequestAdapter

- (void)getHistoryForTokenAddress:(NSString *) tokenAddress
                         andParam:(NSDictionary *) param
                            token:(Contract *) token
               withSuccessHandler:(void (^)(NSArray *responseObject)) success
                andFailureHandler:(void (^)(NSError *error, NSString *message)) failure {
    
    __weak __typeof (self) weakSelf = self;

    [SLocator.requestManager getTokenHistoryWithParam:param
                                         tokenAddress:tokenAddress
                                       successHandler:^(id responseObject) {
        
                                           NSArray <id <HistoryElementProtocol>> *history = [weakSelf createHistoryElements:responseObject withCurrency:token.symbol];
                                           success (history);

    } andFailureHandler:^(NSError *error, NSString *message) {
        failure (error, message);
    }];
}

- (NSArray *)createHistoryElements:(NSDictionary *) responseObject withCurrency:(NSString*) currency{
    
    NSArray* items = responseObject[@"items"];
    NSArray *responseObjectLocal = [[items reverseObjectEnumerator] allObjects];
    NSMutableArray<id <HistoryElementProtocol>> *array = [NSMutableArray new];
    
    for (NSDictionary *dictionary in responseObjectLocal) {
        id <HistoryElementProtocol> element = [self createHistoryElement:dictionary];
        element.currency = currency;
        [array addObject:element];
    }
    
    return array;
}

- (id <HistoryElementProtocol> )createHistoryElement:(NSDictionary *) dictionary {
    
    TokenHistoryElement *element = [TokenHistoryElement new];
    [element setupWithObject:dictionary];
    return element;
}

@end
