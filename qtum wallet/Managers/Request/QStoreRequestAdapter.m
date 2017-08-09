//
//  QStoreRequestAdapter.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreRequestAdapter.h"
#import "QStoreCategory.h"
#import "QStoreFullContractElement.h"

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

- (void)getFullContractById:(NSString *)contractId withSuccessHandler:(void (^)(QStoreFullContractElement *))success andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getFullContractById:contractId withSuccessHandler:^(id responseObject) {
        QStoreFullContractElement *element = [QStoreFullContractElement createFullFromDictionary:responseObject];
        success(element);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

@end
