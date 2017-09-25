//
//  QStoreDataProvider.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreCategory;
@class QStoreContractElement;

typedef NS_ENUM(NSInteger, QStoreDataProviderSearchType) {
    QStoreDataProviderSearchTypeToken,
    QStoreDataProviderSearchTypeCrowdsale,
    QStoreDataProviderSearchTypeOther,
    QStoreDataProviderSearchTypeAll
};

@interface QStoreDataProvider : NSObject

- (void)getContractsForCategory:(QStoreCategory *)category
             withSuccessHandler:(void(^)(QStoreCategory *updatedCategory))success
              andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getFullContractById:(NSString *)contractId
         withSuccessHandler:(void(^)(NSDictionary *fullDictionary))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)searchContractsByCount:(NSInteger)count
                        offset:(NSInteger)offset
                          type:(QStoreDataProviderSearchType)type
                          tags:(NSArray *)tags
            withSuccessHandler:(void(^)(NSArray<QStoreContractElement *> *elements, NSArray<NSString *> *tags))success
             andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getContractABIWithElement:(QStoreContractElement *)element
               withSuccessHandler:(void(^)(NSString *abiString))success
                andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getContractABI:(NSString *)contractId
    withSuccessHandler:(void(^)(NSString *abiString))success
     andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)buyContract:(NSString *)contractId
 withSuccessHandler:(void(^)(NSDictionary *buyRequestDictionary))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)checkRequestPaid:(NSString *)contractId
               requestId:(NSString *)requestId
      withSuccessHandler:(void(^)(NSDictionary *paidObject))success
       andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getSourceCode:(NSString *)contractId
            requestId:(NSString *)requestId
          accessToken:(NSString *)accessToken
   withSuccessHandler:(void(^)(NSString *sourceCode))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getByteCode:(NSString *)contractId
     buyerAddresses:(NSString *)buyerAddresses
              nonce:(NSNumber *)nonce
              signs:(NSArray *)signs
 withSuccessHandler:(void(^)(NSString *byteCode))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getByteCode:(NSString *)contractId
          requestId:(NSString *)requestId
        accessToken:(NSString *)accessToken
 withSuccessHandler:(void(^)(NSString *sourceCode))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

@end
