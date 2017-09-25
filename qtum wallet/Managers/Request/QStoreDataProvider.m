//
//  QStoreDataProvider.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreDataProvider.h"
#import "QStoreCategory.h"
#import "QStoreContractElement.h"

@implementation QStoreDataProvider

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
                          type:(QStoreDataProviderSearchType)type
                          tags:(NSArray *)tags
            withSuccessHandler:(void (^)(NSArray<QStoreContractElement *> *, NSArray<NSString *> *))success
             andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    NSString *stringType;
    switch (type) {
        case QStoreDataProviderSearchTypeToken:
            stringType = @"token";
            break;
        case QStoreDataProviderSearchTypeCrowdsale:
            stringType = @"crowdsale";
            break;
        case QStoreDataProviderSearchTypeOther:
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

- (void)getContractABIWithElement:(QStoreContractElement *)element
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

- (void)getContractABI:(NSString *)contractId
    withSuccessHandler:(void(^)(NSString *abiString))success
     andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getContractABI:contractId withSuccessHandler:^(id responseObject) {
        NSData *jsonData = [NSJSONSerialization  dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *abiString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        success(abiString);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)buyContract:(NSString *)contractId
 withSuccessHandler:(void(^)(NSDictionary *buyRequestDictionary))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager buyContract:contractId withSuccessHandler:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            success(responseObject);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)checkRequestPaid:(NSString *)contractId
               requestId:(NSString *)requestId
      withSuccessHandler:(void(^)(NSDictionary *paidObject))success
       andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager checkRequestPaid:contractId requestId:requestId withSuccessHandler:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            success(responseObject);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getSourceCode:(NSString *)contractId
            requestId:(NSString *)requestId
          accessToken:(NSString *)accessToken
   withSuccessHandler:(void(^)(NSString *sourceCode))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getSourceCode:contractId requestId:requestId accessToken:accessToken withSuccessHandler:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *sourceCode = [responseObject objectForKey:@"source_code"];
            success(sourceCode);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getByteCode:(NSString *)contractId
     buyerAddresses:(NSString *)buyerAddresses
              nonce:(NSNumber *)nonce
              signs:(NSArray *)signs
 withSuccessHandler:(void(^)(NSString *byteCode))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getByteCode:contractId buyerAddresses:buyerAddresses nonce:nonce signs:signs withSuccessHandler:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *byteCode = [responseObject objectForKey:@"bytecode"];
            success(byteCode);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getByteCode:(NSString *)contractId
          requestId:(NSString *)requestId
        accessToken:(NSString *)accessToken
 withSuccessHandler:(void(^)(NSString *sourceCode))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [[ApplicationCoordinator sharedInstance].requestManager getByteCode:contractId requestId:requestId accessToken:accessToken withSuccessHandler:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *byteCode = [responseObject objectForKey:@"bytecode"];
            success(byteCode);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        
    }];
}

@end
