//
//  QStoreManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreCategory;
@class QStoreShortContractElement;
@class QStoreFullContractElement;
@class QStoreSearchContractElement;

typedef NS_ENUM(NSInteger, QStoreManagerSearchType) {
    QStoreManagerSearchTypeNone,
    QStoreManagerSearchTypeTag,
    QStoreManagerSearchTypeName
};

@protocol QStoreManagerSearchDelegate <NSObject>

- (void)didFindElements:(NSArray<QStoreSearchContractElement *> *)elements;
- (void)didFindMoreElements:(NSArray<QStoreSearchContractElement *> *)elements;

@end

@interface QStoreManager : NSObject

@property (weak, nonatomic) id<QStoreManagerSearchDelegate> delegate;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)loadContractsForCategoriesWithSuccessHandler:(void(^)(NSArray<QStoreCategory *> *categories))success
                                   andFailureHandler:(void(^)(NSString* message))failure;

- (void)loadFullContractByShort:(QStoreShortContractElement *)element
             withSuccessHandler:(void (^)(QStoreFullContractElement *))success
              andFailureHandler:(void (^)(NSString *))failure;

- (void)searchByString:(NSString *)string searchType:(QStoreManagerSearchType)type;
- (void)searchMoreItemsByString:(NSString *)string searchType:(QStoreManagerSearchType)type;

- (void)getContractABI:(QStoreFullContractElement *)element
             withSuccessHandler:(void (^)(QStoreFullContractElement *updatedElement))success
              andFailureHandler:(void (^)(NSString *message))failure;
@end
