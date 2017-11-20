//
//  QStoreManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreMainScreenCategory;
@class QStoreContractElement;
@class QStoreBuyRequest;
@class QStoreCategory;

typedef NS_ENUM(NSInteger, QStoreManagerSearchType) {
	QStoreManagerSearchTypeNone,
	QStoreManagerSearchTypeTag,
	QStoreManagerSearchTypeName,
	QStoreManagerSearchTypeAll
};

@protocol QStoreManagerSearchDelegate <NSObject>

- (void)didFindElements:(NSArray<QStoreContractElement *> *) elements;

- (void)didFindMoreElements:(NSArray<QStoreContractElement *> *) elements;

@end

@interface QStoreManager : NSObject <Clearable>

@property (readonly) NSMutableArray<QStoreMainScreenCategory *> *mainScreenCategories;
@property (weak, nonatomic) id <QStoreManagerSearchDelegate> delegate;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));

+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));

+ (instancetype)new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)loadContractsForCategoriesWithSuccessHandler:(void (^)(NSArray<QStoreMainScreenCategory *> *categories)) success
								   andFailureHandler:(void (^)(NSString *message)) failure;

- (void)loadCategoriesWithSuccessHandler:(void (^)(NSArray<QStoreCategory *> *categories)) success
					   andFailureHandler:(void (^)(NSString *message)) failure;

- (void)loadFullContract:(QStoreContractElement *) element
	  withSuccessHandler:(void (^)(void)) success
	   andFailureHandler:(void (^)(NSString *message)) failure;

- (void)searchByCategoryType:(NSString *) categoryType string:(NSString *) string searchType:(QStoreManagerSearchType) type;

- (void)searchMoreItemsByCategoryType:(NSString *) categoryType string:(NSString *) string searchType:(QStoreManagerSearchType) type;

- (void)getContractABIWithElement:(QStoreContractElement *) element
			   withSuccessHandler:(void (^)(void)) success
				andFailureHandler:(void (^)(NSString *message)) failure;

- (void)purchaseContract:(QStoreContractElement *) element
	  withSuccessHandler:(void (^)(void)) success
	   andFailureHandler:(void (^)(NSString *message)) failure;

- (void)checkRequestPaid:(NSString *) contractId
			   requestId:(NSString *) requestId
	  withSuccessHandler:(void (^)(NSDictionary *paidObject)) success
	   andFailureHandler:(void (^)(NSError *error, NSString *message)) failure;

- (void)getSourceCode:(NSString *) contractId
			requestId:(NSString *) requestId
		  accessToken:(NSString *) accessToken
   withSuccessHandler:(void (^)(NSString *sourceCode)) success
	andFailureHandler:(void (^)(NSError *error, NSString *message)) failure;

- (QStoreBuyRequest *)requestWithContractId:(NSString *) contractId;

- (void)startObservingForAllRequests;

- (void)stopObservingForAllRequests;

- (void)updateContractRequestsWithDict:(NSDictionary *) dict;

@end
