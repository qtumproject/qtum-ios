//
//  QStoreMainOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@class QStoreShortContractElement;

@protocol QStoreMainOutputDelegate <NSObject>

- (void)didSelectQStoreCategories;
- (void)didSelectQStoreCategory;
- (void)didSelectQStoreShortContractElement:(QStoreShortContractElement *)element;
- (void)didSelectQStoreContractDetails;
- (void)didPressedBack;
- (void)didLoadTrendingNow;

@end
