//
//  QStoreRequestAdapter.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreRequestAdapter.h"
#import "QStoreCategory.h"
#import "QStoreContractElement.h"

@implementation QStoreRequestAdapter

- (void)getContractsForCategory:(QStoreCategory *)category
             withSuccessHandler:(void(^)(QStoreCategory *updatedCategory))success
              andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getContractsByCategoryPath:category.urlPath withSuccessHandler:^(id responseObject) {
        [category parseElementsFromJSONArray:responseObject];
        success(category);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getFullContractById:(NSString *)contractId withSuccessHandler:(void (^)(NSDictionary *fullDictionary))success andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getFullContractById:contractId withSuccessHandler:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            success(responseObject);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)searchContractsByCount:(NSInteger)count
                        offset:(NSInteger)offset
                          type:(QStoreRequestAdapterSearchType)type
                          tags:(NSArray *)tags
            withSuccessHandler:(void (^)(NSArray<QStoreContractElement *> *, NSArray<NSString *> *))success
             andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    NSString *stringType;
    switch (type) {
        case QStoreRequestAdapterSearchTypeToken:
            stringType = @"token";
            break;
        case QStoreRequestAdapterSearchTypeCrowdsale:
            stringType = @"crowdsale";
            break;
        case QStoreRequestAdapterSearchTypeOther:
            stringType = @"other";
            break;
        default:
            break;
    }
    
    [[ApplicationCoordinator sharedInstance].requestManager searchContractsByCount:count offset:offset type:stringType tags:tags withSuccessHandler:^(id responseObject) {
        NSMutableArray<QStoreContractElement *> *array = [NSMutableArray new];
        for (NSDictionary *dictionary in responseObject) {
            QStoreContractElement *element = [QStoreContractElement createFromSearchDictionary:dictionary];
            [array addObject:element];
        }
        success(array, tags);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getContractABI:(QStoreContractElement *)element
    withSuccessHandler:(void(^)(NSString *abiString))success
     andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
 
    [[ApplicationCoordinator sharedInstance].requestManager getContractABI:element.idString withSuccessHandler:^(id responseObject) {
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *abiString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        success(abiString);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

@end
