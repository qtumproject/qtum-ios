//
//  QStoreListOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListOutputDelegate.h"

@class QStoreCategory;
@class QStoreContractElement;

@protocol QStoreListOutput <NSObject>

typedef NS_ENUM(NSInteger, QStoreListType) {
    QStoreCategories,
    QStoreContracts
};

@property (weak, nonatomic) id<QStoreListOutputDelegate> delegate;

@property (nonatomic) NSString *categoryTitle;
@property (nonatomic) NSString *categoryType;
@property (nonatomic) QStoreListType type;

- (void)setCategories:(NSArray<QStoreCategory *> *)categories;
- (void)setElements:(NSArray<QStoreContractElement *> *)elements;
- (void)setMoreElements:(NSArray<QStoreContractElement *> *)elements;

- (void)startLoading;
- (void)endLoading;
- (void)showErrorWithMessage:(NSString *)message;

@end
