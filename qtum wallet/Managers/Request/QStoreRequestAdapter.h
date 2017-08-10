//
//  QStoreRequestAdapter.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreCategory;
@class QStoreFullContractElement;
@class QStoreSearchContractElement;

typedef NS_ENUM(NSInteger, QStoreRequestAdapterSearchType) {
    QStoreRequestAdapterSearchTypeToken,
    QStoreRequestAdapterSearchTypeCrowdsale,
    QStoreRequestAdapterSearchTypeOther,
    QStoreRequestAdapterSearchTypeAll
};

@interface QStoreRequestAdapter : NSObject

- (void)getContractsForCategory:(QStoreCategory *)category
             withSuccessHandler:(void(^)(QStoreCategory *updatedCategory))success
              andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)getFullContractById:(NSString *)contractId
         withSuccessHandler:(void(^)(QStoreFullContractElement *contract))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

- (void)searchContractsByCount:(NSInteger)count
                        offset:(NSInteger)offset
                          type:(QStoreRequestAdapterSearchType)type
                          tags:(NSArray *)tags
            withSuccessHandler:(void(^)(NSArray<QStoreSearchContractElement *> *elements, NSArray<NSString *> *tags))success
             andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

@end
