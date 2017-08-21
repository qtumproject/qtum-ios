//
//  QStoreManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreCategory;
@class QStoreContractElement;

typedef NS_ENUM(NSInteger, QStoreManagerSearchType) {
    QStoreManagerSearchTypeNone,
    QStoreManagerSearchTypeTag,
    QStoreManagerSearchTypeName
};

@protocol QStoreManagerSearchDelegate <NSObject>

- (void)didFindElements:(NSArray<QStoreContractElement *> *)elements;
- (void)didFindMoreElements:(NSArray<QStoreContractElement *> *)elements;

@end

@interface QStoreManager : NSObject

@property (readonly) NSMutableArray<QStoreCategory *> *categories;
@property (weak, nonatomic) id<QStoreManagerSearchDelegate> delegate;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)loadContractsForCategoriesWithSuccessHandler:(void(^)(NSArray<QStoreCategory *> *categories))success
                                   andFailureHandler:(void(^)(NSString* message))failure;

- (void)loadFullContract:(QStoreContractElement *)element
      withSuccessHandler:(void (^)())success
       andFailureHandler:(void (^)(NSString *message))failure;

- (void)searchByString:(NSString *)string searchType:(QStoreManagerSearchType)type;
- (void)searchMoreItemsByString:(NSString *)string searchType:(QStoreManagerSearchType)type;

- (void)getContractABI:(QStoreContractElement *)element
    withSuccessHandler:(void (^)())success
     andFailureHandler:(void (^)(NSString *message))failure;

- (void)purchaseContract:(QStoreContractElement *)element
      withSuccessHandler:(void (^)())success
       andFailureHandler:(void (^)(NSString *message))failure;

- (void)checkRequestPaid:(NSString *)contractId
               requestId:(NSString *)requestId
      withSuccessHandler:(void(^)(NSDictionary *paidObject))success
       andFailureHandler:(void(^)(NSError * error, NSString* message))failure;

@end
