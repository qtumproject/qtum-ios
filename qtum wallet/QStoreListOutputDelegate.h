//
//  QStoreListOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@class QStoreCategory;
@class QStoreContractElement;
@protocol QStoreListOutput;

@protocol QStoreListOutputDelegate <NSObject>

- (void)didLoadFullData:(NSObject<QStoreListOutput> *)output;
- (void)didLoadMoreFullData:(NSObject<QStoreListOutput> *)output;

- (void)didChangedSearchText:(NSString *)text orSelectedSearchIndex:(NSInteger)index output:(NSObject<QStoreListOutput> *)output;
- (void)didLoadMoreElementsForText:(NSString *)text orSelectedSearchIndex:(NSInteger)index output:(NSObject<QStoreListOutput> *)output;

- (void)didSelectQStoreCategory:(QStoreCategory *)category;
- (void)didSelectQStoreContract:(QStoreContractElement *)element;
- (void)didPressedBack;

@end
