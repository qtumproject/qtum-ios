//
//  QStoreMainOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@protocol QStoreMainOutputDelegate <NSObject>

- (void)didSelectQStoreCategories;
- (void)didSelectQStoreCategory;
- (void)didSelectQStoreContract;
- (void)didSelectQStoreContractDetails;
- (void)didPressedBack;
- (void)didLoadTrendingNow;

@end
