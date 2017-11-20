//
//  QStoreDataProvider.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreDataProvider.h"
#import "QStoreMainScreenCategory.h"
#import "QStoreContractElement.h"

@implementation QStoreDataProvider

- (void)getContractsForCategory:(QStoreMainScreenCategory *)category
             withSuccessHandler:(void(^)(QStoreMainScreenCategory *updatedCategory))success
              andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [SLocator.requestManager getContractsByCategoryPath:category.urlPath withSuccessHandler:^(id responseObject) {
        [category parseElementsFromJSONArray:responseObject];
        success(category);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getFullContractById:(NSString *)contractId withSuccessHandler:(void (^)(NSDictionary *fullDictionary))success andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    [SLocator.requestManager getFullContractById:contractId withSuccessHandler:^(id responseObject) {
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
                          type:(NSString *)type
                          tags:(NSArray *)tags
                          name:(NSString *)name
            withSuccessHandler:(void (^)(NSArray<QStoreContractElement *> *, NSArray<NSString *> *))success
             andFailureHandler:(void (^)(NSError *, NSString *))failure {
    
    
    NSArray *searchArrayToReturnWithResult = tags ? tags : name ? @[name] : nil;
    
    [SLocator.requestManager searchContractsByCount:count offset:offset type:type tags:tags name:name withSuccessHandler:^(id responseObject) {
        NSMutableArray<QStoreContractElement *> *array = [NSMutableArray new];
        for (NSDictionary *dictionary in responseObject) {
            QStoreContractElement *element = [QStoreContractElement createFromSearchDictionary:dictionary];
            [array addObject:element];
        }
        success(array, searchArrayToReturnWithResult);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getContractABIWithElement:(QStoreContractElement *)element
               withSuccessHandler:(void(^)(NSString *abiString))success
                andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
 
    [SLocator.requestManager getContractABI:element.idString withSuccessHandler:^(id responseObject) {
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
    
    [SLocator.requestManager getContractABI:contractId withSuccessHandler:^(id responseObject) {
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
    
    [SLocator.requestManager buyContract:contractId withSuccessHandler:^(id responseObject) {
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
    
    [SLocator.requestManager checkRequestPaid:contractId requestId:requestId withSuccessHandler:^(id responseObject) {
        
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
    
    [SLocator.requestManager getSourceCode:contractId requestId:requestId accessToken:accessToken withSuccessHandler:^(id responseObject) {
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
    
    [SLocator.requestManager getByteCode:contractId buyerAddresses:buyerAddresses nonce:nonce signs:signs withSuccessHandler:^(id responseObject) {
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
    
    [SLocator.requestManager getByteCode:contractId requestId:requestId accessToken:accessToken withSuccessHandler:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSString *byteCode = [responseObject objectForKey:@"bytecode"];
            success(byteCode);
        } else {
            failure([NSError new], @"Not a dictionary");
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        
    }];
}

- (void)getCategories:(void(^)(NSArray<QStoreCategory *> *categories))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [SLocator.requestManager getCategories:^(id responseObject) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *dictionary in responseObject) {
            NSString *identifier = [dictionary objectForKey:@"_id"];
            NSString *name = [dictionary objectForKey:@"type"];
            NSNumber *count = [dictionary objectForKey:@"count"];
            
            if (identifier && name) {
                QStoreCategory *category = [[QStoreCategory alloc] initWithIdentifier:identifier name:name count:count];
                [array addObject:category];
            }
        }
        success(array);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

@end
